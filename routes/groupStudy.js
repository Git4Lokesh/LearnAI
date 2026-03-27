import express from 'express';
import db from '../config/db.js';
import { ensureAuthenticated } from '../middleware/auth.js';
import {
    createRoom, getRoomByCode, getRoomWithMembers, joinRoom, isRoomMember,
    getUserRoomRole, shareContentToRoom, getRoomContent, getUserRooms,
    createStudySession, getRoomSessions, joinStudySession,
    updateGroupProgress, getGroupProgressStats, getQuizLeaderboard, addQuizResult,
    updateUserPresence, getActiveMembers, getRoomChatMessages, saveChatMessage,
    leaveRoom, deleteRoom, getActiveSession, startSession, endSession,
    updateSessionPosition, addAnnotation, getAnnotations, getUserAnalytics,
    getRoomAnalytics, getStudyStreaks, inviteUserToRoom, removeUserFromRoom,
    promoteUser, getSessionParticipants, saveSessionNotes, getSessionNotes,
    getSessionSummary, getUpcomingSessions
} from '../services/groupStudyService.js';

export default function setupGroupStudyRoutes(io) {
    const router = express.Router();

// Group Study Routes
router.get("/group-study", ensureAuthenticated, async (req, res) => {
    try {
        const rooms = await getUserRooms(db, req.user.id);
        res.render("group-study-rooms.ejs", {
            user: req.user,
            rooms: rooms
        });
    } catch (error) {
        console.error('Error loading group study rooms:', error);
        res.status(500).send("Error loading group study");
    }
});

router.get("/group-study/create", ensureAuthenticated, (req, res) => {
    res.render("group-study-create.ejs", { user: req.user });
});

router.post("/group-study/create", ensureAuthenticated, async (req, res) => {
    try {
        const { name, topic, description, privacy, maxParticipants, studyMaterialType } = req.body;

        const room = await createRoom(db, {
            name,
            topic,
            description,
            privacy: privacy || 'public',
            maxParticipants: parseInt(maxParticipants) || 50,
            studyMaterialType,
            ownerId: req.user.id
        });

        res.redirect(`/group-study/room/${room.room_code}`);
    } catch (error) {
        console.error('Error creating room:', error);
        res.status(500).send("Error creating study room");
    }
});

router.get("/group-study/join", ensureAuthenticated, (req, res) => {
    res.render("group-study-join.ejs", { user: req.user });
});

router.post("/group-study/join", ensureAuthenticated, async (req, res) => {
    try {
        const { roomCode } = req.body;

        const room = await getRoomByCode(db, roomCode.toUpperCase());
        if (!room) {
            return res.status(404).send("Room not found");
        }

        // Check if already a member
        const isMember = await isRoomMember(db, room.id, req.user.id);
        if (!isMember) {
            // Join room
            await joinRoom(db, room.id, req.user.id);
        }

        res.redirect(`/group-study/room/${room.room_code}`);
    } catch (error) {
        console.error('Error joining room:', error);
        res.status(500).send(error.message || "Error joining room");
    }
});

router.get("/group-study/room/:roomCode", ensureAuthenticated, async (req, res) => {
    try {
        const { roomCode } = req.params;

        const room = await getRoomByCode(db, roomCode.toUpperCase());
        if (!room) {
            return res.status(404).send("Room not found");
        }

        // Check if user is member
        const isMember = await isRoomMember(db, room.id, req.user.id);
        if (!isMember) {
            // Try to join if public
            if (room.privacy === 'public') {
                try {
                    await joinRoom(db, room.id, req.user.id);
                } catch (joinError) {
                    return res.status(403).send("Cannot join this room");
                }
            } else {
                return res.status(403).send("You must be invited to join this room");
            }
        }

        const roomWithMembers = await getRoomWithMembers(db, room.id);
        const content = await getRoomContent(db, room.id);
        const sessions = await getRoomSessions(db, room.id);
        const progressStats = await getGroupProgressStats(db, room.id);
        const userRole = await getUserRoomRole(db, room.id, req.user.id);
        const chatMessages = await getRoomChatMessages(db, room.id);

        res.render("group-study-room.ejs", {
            user: req.user,
            room: roomWithMembers,
            content: content,
            sessions: sessions,
            progressStats: progressStats,
            userRole: userRole,
            chatMessages: chatMessages
        });
    } catch (error) {
        console.error('Error loading room:', error);
        res.status(500).send("Error loading room");
    }
});

router.post("/group-study/room/:roomId/share", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;
        const { contentType, contentId, title, topic, gradeLevel, contentData } = req.body;

        // Check if user is member
        const isMember = await isRoomMember(db, parseInt(roomId), req.user.id);
        if (!isMember) {
            return res.status(403).json({ error: "Not a member of this room" });
        }

        const shared = await shareContentToRoom(db, {
            roomId: parseInt(roomId),
            contentType,
            contentId: contentId ? parseInt(contentId) : null,
            title,
            topic,
            gradeLevel,
            contentData: typeof contentData === 'string' ? JSON.parse(contentData) : contentData,
            sharedBy: req.user.id
        });

        // Emit to room
        io.to(`room_${roomId}`).emit('content_shared', shared);

        res.json({ success: true, content: shared });
    } catch (error) {
        console.error('Error sharing content:', error);
        res.status(500).json({ error: "Error sharing content" });
    }
});

router.post("/group-study/session/create", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId, title, description, scheduledAt, durationMinutes } = req.body;

        const session = await createStudySession(db, {
            roomId: parseInt(roomId),
            title,
            description,
            scheduledAt: new Date(scheduledAt),
            durationMinutes: parseInt(durationMinutes) || 60,
            createdBy: req.user.id
        });

        io.to(`room_${roomId}`).emit('session_created', session);

        res.json({ success: true, session });
    } catch (error) {
        console.error('Error creating session:', error);
        res.status(500).json({ error: "Error creating session" });
    }
});

router.post("/group-study/quiz/submit", ensureAuthenticated, async (req, res) => {
    try {
        const { roomContentId, score, totalQuestions, timeTakenSeconds, skillId, roomId } = req.body;

        // Add to leaderboard
        await addQuizResult(db, parseInt(roomContentId), req.user.id, parseInt(score), parseInt(totalQuestions), parseInt(timeTakenSeconds));

        // Update group progress if skillId provided
        if (skillId && roomId) {
            const correctAnswers = parseInt(score);
            await updateGroupProgress(db, parseInt(roomId), skillId, req.user.id, correctAnswers / totalQuestions, parseInt(totalQuestions), correctAnswers);
        }

        // Emit leaderboard update
        const leaderboard = await getQuizLeaderboard(db, parseInt(roomContentId));
        io.to(`room_${roomId}`).emit('leaderboard_updated', { roomContentId, leaderboard });

        res.json({ success: true, leaderboard });
    } catch (error) {
        console.error('Error submitting quiz:', error);
        res.status(500).json({ error: "Error submitting quiz" });
    }
});

// Additional group study routes
router.post("/group-study/room/:roomId/invite", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;
        const { email } = req.body;

        const result = await inviteUserToRoom(db, parseInt(roomId), req.user.id, email);

        io.to(`room_${roomId}`).emit('member_added', { userId: result.userId });

        res.json({ success: true });
    } catch (error) {
        console.error('Error inviting user:', error);
        res.status(500).json({ error: error.message || "Error inviting user" });
    }
});

router.delete("/group-study/room/:roomId/leave", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;

        await leaveRoom(db, parseInt(roomId), req.user.id);

        io.to(`room_${roomId}`).emit('member_left', { userId: req.user.id });

        res.json({ success: true });
    } catch (error) {
        console.error('Error leaving room:', error);
        res.status(500).json({ error: error.message || "Error leaving room" });
    }
});

router.delete("/group-study/room/:roomId", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;

        await deleteRoom(db, parseInt(roomId), req.user.id);

        io.to(`room_${roomId}`).emit('room_deleted');

        res.json({ success: true });
    } catch (error) {
        console.error('Error deleting room:', error);
        res.status(500).json({ error: error.message || "Error deleting room" });
    }
});

router.delete("/group-study/room/:roomId/member/:userId", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId, userId } = req.params;

        await removeUserFromRoom(db, parseInt(roomId), req.user.id, parseInt(userId));

        io.to(`room_${roomId}`).emit('member_removed', { userId: parseInt(userId) });

        res.json({ success: true });
    } catch (error) {
        console.error('Error removing member:', error);
        res.status(500).json({ error: error.message || "Error removing member" });
    }
});

router.post("/group-study/room/:roomId/promote/:userId", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId, userId } = req.params;

        await promoteUser(db, parseInt(roomId), req.user.id, parseInt(userId));

        io.to(`room_${roomId}`).emit('member_promoted', { userId: parseInt(userId), role: 'admin' });

        res.json({ success: true });
    } catch (error) {
        console.error('Error promoting user:', error);
        res.status(500).json({ error: error.message || "Error promoting user" });
    }
});

// Session management routes
router.get("/group-study/room/:roomId/sessions/active", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;

        const activeSession = await getActiveSession(db, parseInt(roomId));

        if (activeSession) {
            const participants = await getSessionParticipants(db, activeSession.id);
            activeSession.participants = participants;
        }

        res.json({ session: activeSession });
    } catch (error) {
        console.error('Error getting active session:', error);
        res.status(500).json({ error: "Error getting active session" });
    }
});

router.post("/group-study/sessions/:sessionId/start", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;

        const session = await startSession(db, parseInt(sessionId), req.user.id);

        io.to(`room_${session.room_id}`).emit('session_started', session);

        res.json({ success: true, session });
    } catch (error) {
        console.error('Error starting session:', error);
        res.status(500).json({ error: error.message || "Error starting session" });
    }
});

router.post("/group-study/sessions/:sessionId/end", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;

        const session = await endSession(db, parseInt(sessionId), req.user.id);

        io.to(`room_${session.room_id}`).emit('session_ended', session);

        res.json({ success: true, session });
    } catch (error) {
        console.error('Error ending session:', error);
        res.status(500).json({ error: error.message || "Error ending session" });
    }
});

router.post("/group-study/sessions/:sessionId/sync", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;
        const { position } = req.body;

        await updateSessionPosition(db, parseInt(sessionId), req.user.id, position);

        // Broadcast sync to room
        const sessionResult = await db.query('SELECT room_id FROM study_sessions WHERE id = $1', [sessionId]);
        if (sessionResult.rows.length > 0) {
            io.to(`room_${sessionResult.rows[0].room_id}`).emit('position_synced', {
                sessionId: parseInt(sessionId),
                userId: req.user.id,
                position
            });
        }

        res.json({ success: true });
    } catch (error) {
        console.error('Error syncing position:', error);
        res.status(500).json({ error: "Error syncing position" });
    }
});

router.post("/group-study/sessions/:sessionId/answer", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;
        const { answer, questionIndex, correct } = req.body;

        // Get session info
        const sessionResult = await db.query(
            'SELECT ss.*, rc.room_id FROM study_sessions ss JOIN study_rooms sr ON ss.room_id = sr.id LEFT JOIN room_content rc ON rc.id = ss.content_id WHERE ss.id = $1',
            [sessionId]
        );

        if (sessionResult.rows.length === 0) {
            return res.status(404).json({ error: "Session not found" });
        }

        const session = sessionResult.rows[0];

        // Broadcast answer to room
        io.to(`room_${session.room_id}`).emit('answer_submitted', {
            sessionId: parseInt(sessionId),
            userId: req.user.id,
            questionIndex,
            answer,
            correct
        });

        res.json({ success: true });
    } catch (error) {
        console.error('Error submitting answer:', error);
        res.status(500).json({ error: "Error submitting answer" });
    }
});

// Annotation routes
router.post("/group-study/content/:contentId/annotate", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;
        const { annotationText, positionStart, positionEnd } = req.body;

        const annotation = await addAnnotation(db, {
            roomContentId: parseInt(contentId),
            userId: req.user.id,
            annotationText,
            positionStart: parseInt(positionStart),
            positionEnd: parseInt(positionEnd)
        });

        // Get room ID for broadcasting
        const contentResult = await db.query('SELECT room_id FROM room_content WHERE id = $1', [contentId]);
        if (contentResult.rows.length > 0) {
            io.to(`room_${contentResult.rows[0].room_id}`).emit('annotation_added', annotation);
        }

        res.json({ success: true, annotation });
    } catch (error) {
        console.error('Error adding annotation:', error);
        res.status(500).json({ error: "Error adding annotation" });
    }
});

// Get content with annotations (GENERIC route - must come LAST)
router.get("/group-study/content/:contentId", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;

        const contentResult = await db.query(
            `SELECT rc.*, u.name as shared_by_name
             FROM room_content rc
             JOIN users u ON rc.shared_by = u.id
             WHERE rc.id = $1`,
            [contentId]
        );

        if (contentResult.rows.length === 0) {
            return res.status(404).json({ error: "Content not found" });
        }

        const content = contentResult.rows[0];
        const annotations = await getAnnotations(db, parseInt(contentId));

        res.json({ content, annotations });
    } catch (error) {
        console.error('Error getting content:', error);
        res.status(500).json({ error: "Error getting content" });
    }
});

// Analytics routes
router.get("/group-study/room/:roomId/analytics", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;

        // Verify user is member
        const isMember = await isRoomMember(db, parseInt(roomId), req.user.id);
        if (!isMember) {
            return res.status(403).json({ error: "Not a member of this room" });
        }

        const analytics = await getRoomAnalytics(db, parseInt(roomId));
        const streaks = await getStudyStreaks(db, req.user.id, parseInt(roomId));

        res.json({ analytics, streaks });
    } catch (error) {
        console.error('Error getting analytics:', error);
        res.status(500).json({ error: "Error getting analytics" });
    }
});

router.get("/group-study/room/:roomId/analytics/user/:userId", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId, userId } = req.params;

        // Verify requester is member
        const isMember = await isRoomMember(db, parseInt(roomId), req.user.id);
        if (!isMember) {
            return res.status(403).json({ error: "Not a member of this room" });
        }

        const userAnalytics = await getUserAnalytics(db, parseInt(roomId), parseInt(userId));
        const streaks = await getStudyStreaks(db, parseInt(userId), parseInt(roomId));

        res.json({ analytics: userAnalytics, streaks });
    } catch (error) {
        console.error('Error getting user analytics:', error);
        res.status(500).json({ error: "Error getting user analytics" });
    }
});

// Session notes and summaries
router.post("/group-study/sessions/:sessionId/notes", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;
        const { notesText } = req.body;

        const notes = await saveSessionNotes(db, parseInt(sessionId), req.user.id, notesText);

        res.json({ success: true, notes });
    } catch (error) {
        console.error('Error saving session notes:', error);
        res.status(500).json({ error: "Error saving session notes" });
    }
});

router.get("/group-study/sessions/:sessionId/notes", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;

        const notes = await getSessionNotes(db, parseInt(sessionId));

        res.json({ notes });
    } catch (error) {
        console.error('Error getting session notes:', error);
        res.status(500).json({ error: "Error getting session notes" });
    }
});

router.get("/group-study/sessions/:sessionId/summary", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;

        const summary = await getSessionSummary(db, parseInt(sessionId));

        res.json({ summary });
    } catch (error) {
        console.error('Error getting session summary:', error);
        res.status(500).json({ error: error.message || "Error getting session summary" });
    }
});

// Get quiz leaderboard
router.get("/group-study/quiz/leaderboard/:contentId", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;
        const leaderboard = await getQuizLeaderboard(db, parseInt(contentId));
        res.json({ leaderboard });
    } catch (error) {
        console.error('Error getting leaderboard:', error);
        res.status(500).json({ error: "Error getting leaderboard" });
    }
});

// IMPORTANT: More specific routes must come BEFORE generic routes
// Synchronized session view for flashcards/quizzes
router.get("/group-study/content/:contentId/session", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;
        const { type } = req.query;

        const contentResult = await db.query(
            `SELECT rc.*, sr.id as room_id, sr.name as room_name
             FROM room_content rc
             JOIN study_rooms sr ON rc.room_id = sr.id
             WHERE rc.id = $1`,
            [contentId]
        );

        if (contentResult.rows.length === 0) {
            return res.status(404).send("Content not found");
        }

        const content = contentResult.rows[0];

        // Verify user is member
        const isMember = await isRoomMember(db, content.room_id, req.user.id);
        if (!isMember) {
            return res.status(403).send("Not a member of this room");
        }

        // Get active session or create one
        let session = await getActiveSession(db, content.room_id);

        if (!session) {
            // Create a new session for this content
            session = await createStudySession(db, {
                roomId: content.room_id,
                title: `Study Session: ${content.title || content.topic}`,
                description: `Synchronized ${type} session`,
                scheduledAt: new Date(),
                durationMinutes: 60,
                createdBy: req.user.id
            });

            // Start it immediately
            session = await startSession(db, session.id, req.user.id);
        }

        const participants = await getSessionParticipants(db, session.id);

        res.render("group-study-session.ejs", {
            user: req.user,
            content: content,
            session: session,
            participants: participants,
            contentType: type
        });
    } catch (error) {
        console.error('Error loading session:', error);
        res.status(500).send("Error loading session");
    }
});

// Get content annotations (must come before generic content route)
router.get("/group-study/content/:contentId/annotations", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;

        const annotations = await getAnnotations(db, parseInt(contentId));

        res.json({ annotations });
    } catch (error) {
        console.error('Error getting annotations:', error);
        res.status(500).json({ error: "Error getting annotations" });
    }
});

// View/Edit content with collaborative editing (must come before generic content route)
router.get("/group-study/content/:contentId/edit", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;

        const contentResult = await db.query(
            `SELECT rc.*, sr.id as room_id, sr.name as room_name
             FROM room_content rc
             JOIN study_rooms sr ON rc.room_id = sr.id
             WHERE rc.id = $1`,
            [contentId]
        );

        if (contentResult.rows.length === 0) {
            return res.status(404).send("Content not found");
        }

        const content = contentResult.rows[0];

        // Verify user is member
        const isMember = await isRoomMember(db, content.room_id, req.user.id);
        if (!isMember) {
            return res.status(403).send("Not a member of this room");
        }

        // Only quicknotes can be collaboratively edited
        if (content.content_type !== 'quicknotes') {
            return res.status(400).send("Only notes can be collaboratively edited");
        }

        const annotations = await getAnnotations(db, parseInt(contentId));

        res.render("group-study-editor.ejs", {
            user: req.user,
            content: content,
            room: { id: content.room_id, name: content.room_name },
            annotations: annotations
        });
    } catch (error) {
        console.error('Error loading editor:', error);
        res.status(500).send("Error loading editor");
    }
});

// Get upcoming session reminders
router.get("/group-study/reminders", ensureAuthenticated, async (req, res) => {
    try {
        const upcoming = await getUpcomingSessions(db, req.user.id, 24);
        res.json({ sessions: upcoming });
    } catch (error) {
        console.error('Error getting reminders:', error);
        res.status(500).json({ error: "Error getting reminders" });
    }
});

// View session page
router.get("/group-study/session/:sessionId", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;

        const sessionResult = await db.query(
            `SELECT ss.*, sr.id as room_id, sr.name as room_name
             FROM study_sessions ss
             JOIN study_rooms sr ON ss.room_id = sr.id
             WHERE ss.id = $1`,
            [sessionId]
        );

        if (sessionResult.rows.length === 0) {
            return res.status(404).send("Session not found");
        }

        const session = sessionResult.rows[0];

        // Verify user is member
        const isMember = await isRoomMember(db, session.room_id, req.user.id);
        if (!isMember) {
            return res.status(403).send("Not a member of this room");
        }

        // Get associated content if any
        const contentResult = await db.query(
            'SELECT * FROM room_content WHERE room_id = $1 ORDER BY created_at DESC LIMIT 1',
            [session.room_id]
        );

        const participants = await getSessionParticipants(db, parseInt(sessionId));

        res.render("group-study-session.ejs", {
            user: req.user,
            content: contentResult.rows[0] || null,
            session: session,
            participants: participants,
            contentType: 'quiz' // Default, can be determined from content
        });
    } catch (error) {
        console.error('Error loading session:', error);
        res.status(500).send("Error loading session");
    }
});

    return router;
}
