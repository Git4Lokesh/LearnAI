import crypto from 'crypto';

// Service functions that accept db connection as parameter

// Generate unique room code
export function generateRoomCode() {
    return crypto.randomBytes(6).toString('base64url').substring(0, 8).toUpperCase();
}

// Create a new study room
export async function createRoom(db, roomData) {
    const { name, topic, description, privacy, maxParticipants, studyMaterialType, ownerId } = roomData;
    
    let roomCode;
    let codeExists = true;
    
    // Ensure unique room code
    while (codeExists) {
        roomCode = generateRoomCode();
        const checkResult = await db.query('SELECT id FROM study_rooms WHERE room_code = $1', [roomCode]);
        codeExists = checkResult.rows.length > 0;
    }
    
    const result = await db.query(
        `INSERT INTO study_rooms 
         (room_code, name, topic, description, privacy, max_participants, study_material_type, owner_id)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
         RETURNING *`,
        [roomCode, name, topic, description, privacy || 'public', maxParticipants || 50, studyMaterialType, ownerId]
    );
    
    const room = result.rows[0];
    
    // Add owner as member with owner role
    await db.query(
        `INSERT INTO room_members (room_id, user_id, role)
         VALUES ($1, $2, 'owner')
         ON CONFLICT (room_id, user_id) DO UPDATE SET role = 'owner'`,
        [room.id, ownerId]
    );
    
    return room;
}

// Get room by code
export async function getRoomByCode(db, roomCode) {
    const result = await db.query(
        `SELECT sr.*, u.name as owner_name, u.email as owner_email
         FROM study_rooms sr
         JOIN users u ON sr.owner_id = u.id
         WHERE sr.room_code = $1`,
        [roomCode]
    );
    
    return result.rows[0] || null;
}

// Get room with members
export async function getRoomWithMembers(db, roomId) {
    const roomResult = await db.query(
        `SELECT sr.*, u.name as owner_name
         FROM study_rooms sr
         JOIN users u ON sr.owner_id = u.id
         WHERE sr.id = $1`,
        [roomId]
    );
    
    if (roomResult.rows.length === 0) return null;
    
    const membersResult = await db.query(
        `SELECT rm.*, u.name, u.email, u.id as user_id
         FROM room_members rm
         JOIN users u ON rm.user_id = u.id
         WHERE rm.room_id = $1
         ORDER BY rm.joined_at`,
        [roomId]
    );
    
    return {
        ...roomResult.rows[0],
        members: membersResult.rows
    };
}

// Join a room
export async function joinRoom(db, roomId, userId, role = 'member') {
    // Check if room exists and has space
    const roomResult = await db.query('SELECT max_participants, privacy FROM study_rooms WHERE id = $1', [roomId]);
    if (roomResult.rows.length === 0) {
        throw new Error('Room not found');
    }
    
    const room = roomResult.rows[0];
    
    // Check current member count
    const memberCountResult = await db.query('SELECT COUNT(*) as count FROM room_members WHERE room_id = $1', [roomId]);
    const currentCount = parseInt(memberCountResult.rows[0].count);
    
    if (currentCount >= room.max_participants) {
        throw new Error('Room is full');
    }
    
    // Add member
    const result = await db.query(
        `INSERT INTO room_members (room_id, user_id, role)
         VALUES ($1, $2, $3)
         ON CONFLICT (room_id, user_id) DO UPDATE SET last_active = CURRENT_TIMESTAMP
         RETURNING *`,
        [roomId, userId, role]
    );
    
    return result.rows[0];
}

// Check if user is member of room
export async function isRoomMember(db, roomId, userId) {
    const result = await db.query(
        'SELECT * FROM room_members WHERE room_id = $1 AND user_id = $2',
        [roomId, userId]
    );
    
    return result.rows.length > 0;
}

// Get user's role in room
export async function getUserRoomRole(db, roomId, userId) {
    const result = await db.query(
        'SELECT role FROM room_members WHERE room_id = $1 AND user_id = $2',
        [roomId, userId]
    );
    
    return result.rows.length > 0 ? result.rows[0].role : null;
}

// Share content to room
export async function shareContentToRoom(db, roomContent) {
    const { roomId, contentType, contentId, title, topic, gradeLevel, contentData, sharedBy } = roomContent;
    
    const result = await db.query(
        `INSERT INTO room_content 
         (room_id, content_type, content_id, title, topic, grade_level, content_data, shared_by)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
         RETURNING *`,
        [roomId, contentType, contentId, title, topic, gradeLevel, JSON.stringify(contentData), sharedBy]
    );
    
    return result.rows[0];
}

// Get room content
export async function getRoomContent(db, roomId) {
    const result = await db.query(
        `SELECT rc.*, u.name as shared_by_name
         FROM room_content rc
         JOIN users u ON rc.shared_by = u.id
         WHERE rc.room_id = $1
         ORDER BY rc.created_at DESC`,
        [roomId]
    );
    
    return result.rows;
}

// Get user's rooms
export async function getUserRooms(db, userId) {
    const result = await db.query(
        `SELECT sr.*, rm.role, rm.joined_at, 
                (SELECT COUNT(*) FROM room_members WHERE room_id = sr.id) as member_count
         FROM study_rooms sr
         JOIN room_members rm ON sr.id = rm.room_id
         WHERE rm.user_id = $1
         ORDER BY rm.joined_at DESC`,
        [userId]
    );
    
    return result.rows;
}

// Create study session
export async function createStudySession(db, sessionData) {
    const { roomId, title, description, scheduledAt, durationMinutes, createdBy } = sessionData;
    
    const result = await db.query(
        `INSERT INTO study_sessions 
         (room_id, title, description, scheduled_at, duration_minutes, created_by)
         VALUES ($1, $2, $3, $4, $5, $6)
         RETURNING *`,
        [roomId, title, description, scheduledAt, durationMinutes || 60, createdBy]
    );
    
    return result.rows[0];
}

// Get room sessions
export async function getRoomSessions(db, roomId, status = null) {
    let query = `
        SELECT ss.*, u.name as created_by_name,
               (SELECT COUNT(*) FROM session_participants WHERE session_id = ss.id) as participant_count
        FROM study_sessions ss
        JOIN users u ON ss.created_by = u.id
        WHERE ss.room_id = $1
    `;
    
    const params = [roomId];
    
    if (status) {
        query += ' AND ss.status = $2';
        params.push(status);
    }
    
    query += ' ORDER BY ss.scheduled_at DESC';
    
    const result = await db.query(query, params);
    return result.rows;
}

// Join study session
export async function joinStudySession(db, sessionId, userId) {
    const result = await db.query(
        `INSERT INTO session_participants (session_id, user_id)
         VALUES ($1, $2)
         ON CONFLICT (session_id, user_id) DO NOTHING
         RETURNING *`,
        [sessionId, userId]
    );
    
    return result.rows[0];
}

// Update group progress
export async function updateGroupProgress(db, roomId, skillId, userId, masteryScore, questionsAnswered, correctAnswers) {
    const result = await db.query(
        `INSERT INTO group_progress 
         (room_id, skill_id, user_id, mastery_score, questions_answered, correct_answers)
         VALUES ($1, $2, $3, $4, $5, $6)
         ON CONFLICT (room_id, skill_id, user_id)
         DO UPDATE SET 
             mastery_score = EXCLUDED.mastery_score,
             questions_answered = group_progress.questions_answered + EXCLUDED.questions_answered,
             correct_answers = group_progress.correct_answers + EXCLUDED.correct_answers,
             last_updated = CURRENT_TIMESTAMP
         RETURNING *`,
        [roomId, skillId, userId, masteryScore, questionsAnswered, correctAnswers]
    );
    
    return result.rows[0];
}

// Get group progress statistics
export async function getGroupProgressStats(db, roomId, skillId = null) {
    let query = `
        SELECT 
            skill_id,
            COUNT(DISTINCT user_id) as participant_count,
            AVG(mastery_score) as avg_mastery,
            SUM(questions_answered) as total_questions,
            SUM(correct_answers) as total_correct,
            ROUND(AVG(mastery_score) * 100, 2) as avg_mastery_percent
        FROM group_progress
        WHERE room_id = $1
    `;
    
    const params = [roomId];
    
    if (skillId) {
        query += ' AND skill_id = $2';
        params.push(skillId);
    }
    
    query += ' GROUP BY skill_id ORDER BY skill_id';
    
    const result = await db.query(query, params);
    return result.rows;
}

// Get quiz leaderboard
export async function getQuizLeaderboard(db, roomContentId) {
    const result = await db.query(
        `SELECT ql.*, u.name as user_name
         FROM quiz_leaderboard ql
         JOIN users u ON ql.user_id = u.id
         WHERE ql.room_content_id = $1
         ORDER BY ql.score DESC, ql.time_taken_seconds ASC
         LIMIT 50`,
        [roomContentId]
    );
    
    return result.rows;
}

// Add quiz result to leaderboard
export async function addQuizResult(db, roomContentId, userId, score, totalQuestions, timeTakenSeconds) {
    const result = await db.query(
        `INSERT INTO quiz_leaderboard 
         (room_content_id, user_id, score, total_questions, time_taken_seconds)
         VALUES ($1, $2, $3, $4, $5)
         ON CONFLICT (room_content_id, user_id)
         DO UPDATE SET 
             score = GREATEST(quiz_leaderboard.score, EXCLUDED.score),
             time_taken_seconds = LEAST(quiz_leaderboard.time_taken_seconds, EXCLUDED.time_taken_seconds),
             completed_at = CURRENT_TIMESTAMP
         RETURNING *`,
        [roomContentId, userId, score, totalQuestions, timeTakenSeconds]
    );
    
    return result.rows[0];
}

// Update user presence (last_active)
export async function updateUserPresence(db, roomId, userId) {
    await db.query(
        'UPDATE room_members SET last_active = CURRENT_TIMESTAMP WHERE room_id = $1 AND user_id = $2',
        [roomId, userId]
    );
}

// Get active members (last 5 minutes)
export async function getActiveMembers(db, roomId) {
    const result = await db.query(
        `SELECT rm.*, u.name, u.email
         FROM room_members rm
         JOIN users u ON rm.user_id = u.id
         WHERE rm.room_id = $1 
         AND rm.last_active > NOW() - INTERVAL '5 minutes'
         ORDER BY rm.last_active DESC`,
        [roomId]
    );
    
    return result.rows;
}

// Get room chat messages
export async function getRoomChatMessages(db, roomId, limit = 50) {
    const result = await db.query(
        `SELECT rcm.*, u.name as user_name
         FROM room_chat_messages rcm
         JOIN users u ON rcm.user_id = u.id
         WHERE rcm.room_id = $1
         ORDER BY rcm.created_at DESC
         LIMIT $2`,
        [roomId, limit]
    );
    
    return result.rows.reverse(); // Return oldest first
}

// Save chat message
export async function saveChatMessage(db, roomId, userId, message) {
    const result = await db.query(
        `INSERT INTO room_chat_messages (room_id, user_id, message)
         VALUES ($1, $2, $3)
         RETURNING *`,
        [roomId, userId, message]
    );
    
    return result.rows[0];
}

// Leave room
export async function leaveRoom(db, roomId, userId) {
    // Don't allow owner to leave without deleting room
    const roleResult = await db.query(
        'SELECT role FROM room_members WHERE room_id = $1 AND user_id = $2',
        [roomId, userId]
    );
    
    if (roleResult.rows.length === 0) {
        throw new Error('Not a member of this room');
    }
    
    if (roleResult.rows[0].role === 'owner') {
        throw new Error('Owner cannot leave room. Delete the room instead.');
    }
    
    await db.query(
        'DELETE FROM room_members WHERE room_id = $1 AND user_id = $2',
        [roomId, userId]
    );
    
    return { success: true };
}

// Delete room (owner only)
export async function deleteRoom(db, roomId, userId) {
    // Verify ownership
    const roleResult = await db.query(
        'SELECT role FROM room_members WHERE room_id = $1 AND user_id = $2',
        [roomId, userId]
    );
    
    if (roleResult.rows.length === 0 || roleResult.rows[0].role !== 'owner') {
        throw new Error('Only room owner can delete the room');
    }
    
    // Cascade delete will handle all related records
    await db.query('DELETE FROM study_rooms WHERE id = $1', [roomId]);
    
    return { success: true };
}

// Get active session for room
export async function getActiveSession(db, roomId) {
    const result = await db.query(
        `SELECT ss.*, u.name as created_by_name,
                (SELECT COUNT(*) FROM session_participants WHERE session_id = ss.id) as participant_count
         FROM study_sessions ss
         JOIN users u ON ss.created_by = u.id
         WHERE ss.room_id = $1 AND ss.status = 'active'
         ORDER BY ss.started_at DESC
         LIMIT 1`,
        [roomId]
    );
    
    return result.rows[0] || null;
}

// Start session
export async function startSession(db, sessionId, userId) {
    // Verify user has permission
    const sessionResult = await db.query(
        'SELECT ss.*, sr.owner_id FROM study_sessions ss JOIN study_rooms sr ON ss.room_id = sr.id WHERE ss.id = $1',
        [sessionId]
    );
    
    if (sessionResult.rows.length === 0) {
        throw new Error('Session not found');
    }
    
    const session = sessionResult.rows[0];
    
    // Check if user is room owner or session creator
    if (session.created_by !== userId && session.owner_id !== userId) {
        // Check if user is admin
        const memberResult = await db.query(
            'SELECT role FROM room_members WHERE room_id = $1 AND user_id = $2',
            [session.room_id, userId]
        );
        
        if (memberResult.rows.length === 0 || !['owner', 'admin'].includes(memberResult.rows[0].role)) {
            throw new Error('Permission denied');
        }
    }
    
    const result = await db.query(
        `UPDATE study_sessions 
         SET status = 'active', started_at = CURRENT_TIMESTAMP
         WHERE id = $1
         RETURNING *`,
        [sessionId]
    );
    
    return result.rows[0];
}

// End session
export async function endSession(db, sessionId, userId) {
    // Similar permission check as startSession
    const sessionResult = await db.query(
        'SELECT ss.*, sr.owner_id FROM study_sessions ss JOIN study_rooms sr ON ss.room_id = sr.id WHERE ss.id = $1',
        [sessionId]
    );
    
    if (sessionResult.rows.length === 0) {
        throw new Error('Session not found');
    }
    
    const session = sessionResult.rows[0];
    
    if (session.created_by !== userId && session.owner_id !== userId) {
        const memberResult = await db.query(
            'SELECT role FROM room_members WHERE room_id = $1 AND user_id = $2',
            [session.room_id, userId]
        );
        
        if (memberResult.rows.length === 0 || !['owner', 'admin'].includes(memberResult.rows[0].role)) {
            throw new Error('Permission denied');
        }
    }
    
    const result = await db.query(
        `UPDATE study_sessions 
         SET status = 'completed', ended_at = CURRENT_TIMESTAMP
         WHERE id = $1
         RETURNING *`,
        [sessionId]
    );
    
    return result.rows[0];
}

// Update session participant position
export async function updateSessionPosition(db, sessionId, userId, position) {
    await db.query(
        `INSERT INTO session_participants (session_id, user_id, joined_at)
         VALUES ($1, $2, CURRENT_TIMESTAMP)
         ON CONFLICT (session_id, user_id) DO NOTHING`,
        [sessionId, userId]
    );
    
    // Note: position tracking would need a new column or separate table
    // For now, we'll use WebSocket for real-time sync
    return { success: true, position };
}

// Add annotation
export async function addAnnotation(db, annotationData) {
    const { roomContentId, userId, annotationText, positionStart, positionEnd } = annotationData;
    
    const result = await db.query(
        `INSERT INTO room_annotations 
         (room_content_id, user_id, annotation_text, position_start, position_end)
         VALUES ($1, $2, $3, $4, $5)
         RETURNING *`,
        [roomContentId, userId, annotationText, positionStart, positionEnd]
    );
    
    return result.rows[0];
}

// Get annotations for content
export async function getAnnotations(db, roomContentId) {
    const result = await db.query(
        `SELECT ra.*, u.name as user_name
         FROM room_annotations ra
         JOIN users u ON ra.user_id = u.id
         WHERE ra.room_content_id = $1
         ORDER BY ra.position_start`,
        [roomContentId]
    );
    
    return result.rows;
}

// Get user analytics
export async function getUserAnalytics(db, roomId, userId) {
    const result = await db.query(
        `SELECT 
            skill_id,
            mastery_score,
            questions_answered,
            correct_answers,
            ROUND((correct_answers::DECIMAL / NULLIF(questions_answered, 0)) * 100, 2) as accuracy,
            last_updated
         FROM group_progress
         WHERE room_id = $1 AND user_id = $2
         ORDER BY last_updated DESC`,
        [roomId, userId]
    );
    
    return result.rows;
}

// Get room analytics summary
export async function getRoomAnalytics(db, roomId) {
    const result = await db.query(
        `SELECT 
            COUNT(DISTINCT gp.user_id) as total_participants,
            COUNT(DISTINCT gp.skill_id) as skills_tracked,
            SUM(gp.questions_answered) as total_questions,
            SUM(gp.correct_answers) as total_correct,
            ROUND(AVG(gp.mastery_score) * 100, 2) as avg_mastery,
            COUNT(DISTINCT rc.id) as shared_content_count,
            COUNT(DISTINCT ss.id) as total_sessions
         FROM group_progress gp
         FULL OUTER JOIN room_content rc ON rc.room_id = gp.room_id
         FULL OUTER JOIN study_sessions ss ON ss.room_id = gp.room_id
         WHERE (gp.room_id = $1 OR rc.room_id = $1 OR ss.room_id = $1)
         GROUP BY gp.room_id, rc.room_id, ss.room_id`,
        [roomId]
    );
    
    return result.rows[0] || {
        total_participants: 0,
        skills_tracked: 0,
        total_questions: 0,
        total_correct: 0,
        avg_mastery: 0,
        shared_content_count: 0,
        total_sessions: 0
    };
}

// Get study streaks (days of consecutive study)
export async function getStudyStreaks(db, userId, roomId = null) {
    let query = `
        WITH daily_study AS (
            SELECT 
                DATE(last_updated) as study_date,
                COUNT(*) as activities
            FROM group_progress
            WHERE user_id = $1
    `;
    
    const params = [userId];
    
    if (roomId) {
        query += ' AND room_id = $2';
        params.push(roomId);
    }
    
    query += `
            GROUP BY DATE(last_updated)
        ),
        ordered_dates AS (
            SELECT study_date,
                   ROW_NUMBER() OVER (ORDER BY study_date DESC) as rn,
                   LAG(study_date) OVER (ORDER BY study_date DESC) as prev_date
            FROM daily_study
        )
        SELECT 
            COUNT(*) FILTER (WHERE prev_date IS NULL OR prev_date = study_date + INTERVAL '1 day') as current_streak,
            MAX(study_date) as last_study_date
        FROM ordered_dates
        WHERE rn = 1 OR (prev_date IS NOT NULL AND prev_date = study_date + INTERVAL '1 day')
    `;
    
    const result = await db.query(query, params);
    return result.rows[0] || { current_streak: 0, last_study_date: null };
}

// Invite user to room (by email)
export async function inviteUserToRoom(db, roomId, inviterId, userEmail) {
    // Verify inviter has permission
    const inviterRole = await getUserRoomRole(db, roomId, inviterId);
    if (!inviterRole || !['owner', 'admin'].includes(inviterRole)) {
        throw new Error('Only owners and admins can invite users');
    }
    
    // Find user by email
    const userResult = await db.query('SELECT id FROM users WHERE email = $1', [userEmail]);
    if (userResult.rows.length === 0) {
        throw new Error('User not found');
    }
    
    const invitedUserId = userResult.rows[0].id;
    
    // Check if already a member
    const isMember = await isRoomMember(db, roomId, invitedUserId);
    if (isMember) {
        throw new Error('User is already a member');
    }
    
    // Add as member
    await joinRoom(db, roomId, invitedUserId);
    
    return { success: true, userId: invitedUserId };
}

// Remove user from room (kick)
export async function removeUserFromRoom(db, roomId, removerId, targetUserId) {
    // Verify remover has permission
    const removerRole = await getUserRoomRole(db, roomId, removerId);
    if (!removerRole || !['owner', 'admin'].includes(removerRole)) {
        throw new Error('Only owners and admins can remove users');
    }
    
    // Check target user role
    const targetRole = await getUserRoomRole(db, roomId, targetUserId);
    if (!targetRole) {
        throw new Error('User is not a member');
    }
    
    // Can't remove owner
    if (targetRole === 'owner') {
        throw new Error('Cannot remove room owner');
    }
    
    // Admins can only remove members, not other admins
    if (removerRole === 'admin' && targetRole === 'admin') {
        throw new Error('Admins cannot remove other admins');
    }
    
    await db.query(
        'DELETE FROM room_members WHERE room_id = $1 AND user_id = $2',
        [roomId, targetUserId]
    );
    
    return { success: true };
}

// Promote user to admin
export async function promoteUser(db, roomId, promoterId, targetUserId) {
    // Only owner can promote
    const promoterRole = await getUserRoomRole(db, roomId, promoterId);
    if (promoterRole !== 'owner') {
        throw new Error('Only room owner can promote users');
    }
    
    await db.query(
        'UPDATE room_members SET role = $1 WHERE room_id = $2 AND user_id = $3',
        ['admin', roomId, targetUserId]
    );
    
    return { success: true };
}

// Get session participants
export async function getSessionParticipants(db, sessionId) {
    const result = await db.query(
        `SELECT sp.*, u.name, u.email
         FROM session_participants sp
         JOIN users u ON sp.user_id = u.id
         WHERE sp.session_id = $1
         ORDER BY sp.joined_at`,
        [sessionId]
    );
    
    return result.rows;
}

// Save session notes
export async function saveSessionNotes(db, sessionId, userId, notesText) {
    // Check if notes exist
    const existingResult = await db.query(
        'SELECT id FROM session_notes WHERE session_id = $1 AND user_id = $2',
        [sessionId, userId]
    );
    
    let result;
    if (existingResult.rows.length > 0) {
        result = await db.query(
            `UPDATE session_notes 
             SET notes_text = $1, updated_at = CURRENT_TIMESTAMP
             WHERE session_id = $2 AND user_id = $3
             RETURNING *`,
            [notesText, sessionId, userId]
        );
    } else {
        result = await db.query(
            `INSERT INTO session_notes (session_id, user_id, notes_text)
             VALUES ($1, $2, $3)
             RETURNING *`,
            [sessionId, userId, notesText]
        );
    }
    
    return result.rows[0];
}

// Get session notes
export async function getSessionNotes(db, sessionId) {
    const result = await db.query(
        `SELECT sn.*, u.name as user_name
         FROM session_notes sn
         JOIN users u ON sn.user_id = u.id
         WHERE sn.session_id = $1
         ORDER BY sn.updated_at DESC`,
        [sessionId]
    );
    
    return result.rows;
}

// Get upcoming sessions (for reminders)
export async function getUpcomingSessions(db, userId, hoursAhead = 24) {
    const result = await db.query(
        `SELECT ss.*, sr.name as room_name, sr.topic as room_topic
         FROM study_sessions ss
         JOIN study_rooms sr ON ss.room_id = sr.id
         JOIN room_members rm ON sr.id = rm.room_id
         WHERE rm.user_id = $1
         AND ss.status = 'scheduled'
         AND ss.scheduled_at BETWEEN NOW() AND NOW() + INTERVAL '${hoursAhead} hours'
         ORDER BY ss.scheduled_at ASC`,
        [userId]
    );
    
    return result.rows;
}

// Generate post-session summary
export async function getSessionSummary(db, sessionId) {
    const sessionResult = await db.query(
        `SELECT ss.*, sr.name as room_name, sr.topic
         FROM study_sessions ss
         JOIN study_rooms sr ON ss.room_id = sr.id
         WHERE ss.id = $1`,
        [sessionId]
    );
    
    if (sessionResult.rows.length === 0) {
        throw new Error('Session not found');
    }
    
    const session = sessionResult.rows[0];
    const participants = await getSessionParticipants(db, sessionId);
    
    // Get activity during session
    const activityResult = await db.query(
        `SELECT COUNT(*) as message_count
         FROM room_chat_messages
         WHERE room_id = $1 AND created_at BETWEEN $2 AND $3`,
        [session.room_id, session.started_at, session.ended_at || 'NOW()']
    );
    
    return {
        session,
        participants: participants.length,
        participantNames: participants.map(p => p.name),
        messageCount: parseInt(activityResult.rows[0]?.message_count || 0),
        duration: session.ended_at 
            ? Math.round((new Date(session.ended_at) - new Date(session.started_at)) / 60000)
            : null
    };
}

