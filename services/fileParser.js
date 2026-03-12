import XLSX from 'xlsx';

/**
 * Parse an uploaded CSV or XLSX file buffer into an array of row objects.
 * Column headers become the keys of each row object.
 *
 * @param {Buffer} buffer - The file contents as a Buffer
 * @param {string} filename - Original filename (used for format detection by xlsx)
 * @returns {Array<Object>} Array of row objects with column headers as keys
 */
export function parseUploadedFile(buffer, filename) {
    const workbook = XLSX.read(buffer, { type: 'buffer' });
    const sheet = workbook.Sheets[workbook.SheetNames[0]];
    const rows = XLSX.utils.sheet_to_json(sheet, { defval: '' });
    return rows;
}
