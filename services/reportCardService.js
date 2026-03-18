import PDFDocument from 'pdfkit';

/**
 * Compile a student's mastery data into a structured ReportData object.
 * Groups by subject → chapter → concept with computed averages.
 *
 * @param {import('pg').Pool} db
 * @param {number} studentId
 * @param {number} instituteId
 * @returns {Promise<object>} ReportData
 */
export async function compileReportData(db, studentId, instituteId) {
  // Fetch student name
  const studentResult = await db.query(
    'SELECT name FROM users WHERE id = $1 AND institute_id = $2',
    [studentId, instituteId]
  );
  if (studentResult.rows.length === 0) {
    throw new Error('Student not found in this institute');
  }
  const studentName = studentResult.rows[0].name || 'Unknown Student';

  // Fetch institute name
  const instituteResult = await db.query(
    'SELECT name FROM institutes WHERE id = $1',
    [instituteId]
  );
  const instituteName = instituteResult.rows[0]?.name || 'Unknown Institute';

  // Fetch all chapters with their concepts and the student's mastery
  const dataResult = await db.query(`
    SELECT
      ch.id AS chapter_id,
      ch.name AS chapter_name,
      ch.subject,
      ch.display_order,
      c.id AS concept_id,
      c.name AS concept_name,
      COALESCE(ucm.mastery, 0.2) AS mastery
    FROM chapters ch
    JOIN concepts c ON c.chapter_id = ch.id
    LEFT JOIN user_concept_mastery ucm
      ON ucm.concept_id = c.id AND ucm.user_id = $1
    ORDER BY ch.display_order, c.name
  `, [studentId]);

  // Group into subject → chapter → concept hierarchy
  const subjectMap = new Map();

  for (const row of dataResult.rows) {
    // Determine top-level subject group
    const subjectGroup = getSubjectGroup(row.subject);

    if (!subjectMap.has(subjectGroup)) {
      subjectMap.set(subjectGroup, { name: subjectGroup, chaptersMap: new Map() });
    }
    const subject = subjectMap.get(subjectGroup);

    if (!subject.chaptersMap.has(row.chapter_id)) {
      subject.chaptersMap.set(row.chapter_id, {
        id: row.chapter_id,
        name: row.chapter_name,
        displayOrder: row.display_order,
        concepts: []
      });
    }
    const chapter = subject.chaptersMap.get(row.chapter_id);

    chapter.concepts.push({
      id: row.concept_id,
      name: row.concept_name,
      mastery: parseFloat(row.mastery)
    });
  }

  // Compute averages and build final structure
  const subjectOrder = ['Physics', 'Chemistry', 'Mathematics'];
  const subjects = [];

  for (const subjectName of subjectOrder) {
    const subjectData = subjectMap.get(subjectName);
    if (!subjectData) continue;

    const chapters = Array.from(subjectData.chaptersMap.values())
      .sort((a, b) => a.displayOrder - b.displayOrder)
      .map(ch => {
        const chapterMastery = ch.concepts.length > 0
          ? ch.concepts.reduce((sum, c) => sum + c.mastery, 0) / ch.concepts.length
          : 0.2;
        return {
          id: ch.id,
          name: ch.name,
          mastery: chapterMastery,
          concepts: ch.concepts
        };
      });

    const overallMastery = chapters.length > 0
      ? chapters.reduce((sum, ch) => sum + ch.mastery, 0) / chapters.length
      : 0.2;

    subjects.push({
      name: subjectName,
      overallMastery,
      chapters
    });
  }

  return {
    studentName,
    instituteName,
    generatedAt: new Date(),
    subjects
  };
}

/**
 * Map database subject strings to top-level subject groups.
 */
function getSubjectGroup(subject) {
  if (subject.startsWith('Physics')) return 'Physics';
  if (subject.startsWith('Chemistry')) return 'Chemistry';
  if (subject.startsWith('Mathematics')) return 'Mathematics';
  return subject;
}

/**
 * Get color for a mastery value: green ≥ 80%, yellow 50-80%, red < 50%.
 */
function getMasteryColor(mastery) {
  if (mastery >= 0.8) return '#22c55e'; // green
  if (mastery >= 0.5) return '#eab308'; // yellow
  return '#ef4444'; // red
}

/**
 * Sanitize a student name for use in a filename.
 * Replaces spaces with underscores, removes special characters.
 */
export function sanitizeFilename(name) {
  return name
    .replace(/\s+/g, '_')
    .replace(/[^a-zA-Z0-9_]/g, '');
}

/**
 * Generate a PDF report card from compiled ReportData.
 *
 * @param {object} reportData - The compiled ReportData object
 * @returns {PDFDocument} A PDFKit document stream
 */
export function generateReportPDF(reportData) {
  const doc = new PDFDocument({ size: 'A4', margin: 50 });

  const pageWidth = doc.page.width - 100; // 50 margin each side

  // --- Header ---
  doc.fontSize(22).font('Helvetica-Bold').text('Learn.ai', { align: 'center' });
  doc.moveDown(0.3);
  doc.fontSize(14).font('Helvetica').text('Student Report Card', { align: 'center' });
  doc.moveDown(0.5);

  doc.fontSize(10).font('Helvetica');
  doc.text(`Student: ${reportData.studentName}`, 50);
  doc.text(`Institute: ${reportData.instituteName}`, 50);
  doc.text(`Date: ${reportData.generatedAt.toISOString().split('T')[0]}`, 50);
  doc.moveDown(1);

  // Divider
  doc.moveTo(50, doc.y).lineTo(50 + pageWidth, doc.y).stroke();
  doc.moveDown(0.5);

  // --- Subject Summary ---
  doc.fontSize(14).font('Helvetica-Bold').text('Subject Summary', 50);
  doc.moveDown(0.5);

  for (const subject of reportData.subjects) {
    const pct = Math.round(subject.overallMastery * 100);
    const color = getMasteryColor(subject.overallMastery);

    doc.fontSize(11).font('Helvetica-Bold').fillColor('#000000')
      .text(`${subject.name}: `, 60, doc.y, { continued: true });
    doc.fillColor(color).text(`${pct}%`);
    doc.fillColor('#000000');

    // Mastery bar
    const barY = doc.y;
    const barWidth = 200;
    const barHeight = 8;
    doc.rect(60, barY, barWidth, barHeight).fill('#e5e7eb');
    doc.rect(60, barY, barWidth * subject.overallMastery, barHeight).fill(color);
    doc.y = barY + barHeight + 8;
  }

  doc.moveDown(1);

  // --- Chapter Breakdown per Subject ---
  for (const subject of reportData.subjects) {
    // Check if we need a new page
    if (doc.y > 650) doc.addPage();

    doc.fontSize(13).font('Helvetica-Bold').fillColor('#000000')
      .text(subject.name, 50);
    doc.moveDown(0.3);

    for (const chapter of subject.chapters) {
      if (doc.y > 700) doc.addPage();

      const chPct = Math.round(chapter.mastery * 100);
      const chColor = getMasteryColor(chapter.mastery);

      // Chapter name and mastery
      doc.fontSize(10).font('Helvetica-Bold').fillColor('#000000')
        .text(`${chapter.name}`, 60, doc.y, { continued: true });
      doc.font('Helvetica').fillColor(chColor).text(` — ${chPct}%`);
      doc.fillColor('#000000');

      // Chapter mastery bar
      const chBarY = doc.y;
      const chBarWidth = 150;
      const chBarHeight = 6;
      doc.rect(60, chBarY, chBarWidth, chBarHeight).fill('#e5e7eb');
      doc.rect(60, chBarY, chBarWidth * chapter.mastery, chBarHeight).fill(chColor);
      doc.y = chBarY + chBarHeight + 4;

      // Concept details
      for (const concept of chapter.concepts) {
        if (doc.y > 720) doc.addPage();

        const cPct = Math.round(concept.mastery * 100);
        const cColor = getMasteryColor(concept.mastery);

        doc.fontSize(8).font('Helvetica').fillColor('#555555')
          .text(`• ${concept.name}: `, 80, doc.y, { continued: true });
        doc.fillColor(cColor).text(`${cPct}%`);
        doc.fillColor('#000000');
      }

      doc.moveDown(0.3);
    }

    doc.moveDown(0.5);
  }

  doc.end();
  return doc;
}
