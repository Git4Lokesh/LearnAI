import axios from "axios";

const baseUrl = process.env.BKT_BASE_URL || "http://localhost:8000";

export async function bktUpdate({ userId, skillId, correct, p_mastery = 0.2, p_learn, p_guess, p_slip }) {
    const { data } = await axios.post(`${baseUrl}/update`, {
        userId, skillId, correct, p_mastery, p_learn, p_guess, p_slip
    }, { timeout: 5000 });
    return data;
}

export async function bktNext({ userId, skillId, p_mastery = 0.2 }) {
    const { data } = await axios.post(`${baseUrl}/next`, { userId, skillId, p_mastery }, { timeout: 5000 });
    return data;
}

export async function bktUpdateConcept({ userId, skillId, correct, p_mastery = 0.2, difficulty_tier = 2, time_taken_seconds = null }) {
    const { data } = await axios.post(`${baseUrl}/update-concept`, {
        userId: String(userId), skillId, correct, p_mastery, difficulty_tier, time_taken_seconds
    }, { timeout: 5000 });
    return data;
}

export async function bktNextConcept({ userId, subject = null }) {
    const { data } = await axios.post(`${baseUrl}/next-concept`, {
        userId: parseInt(userId), subject
    }, { timeout: 5000 });
    return data;
}

// ── EM Parameter Learning ──

export async function bktFit(triggeredBy = 'admin') {
    const { data } = await axios.post(`${baseUrl}/fit`, null, {
        params: { triggered_by: triggeredBy },
        timeout: 120000  // EM can take a while
    });
    return data;
}

export async function bktFitDry() {
    const { data } = await axios.post(`${baseUrl}/fit-dry`, null, { timeout: 120000 });
    return data;
}

export async function bktGetParams(conceptId) {
    const { data } = await axios.get(`${baseUrl}/params/${conceptId}`, { timeout: 5000 });
    return data;
}

export async function bktGetAllParams() {
    const { data } = await axios.get(`${baseUrl}/params`, { timeout: 5000 });
    return data;
}

export async function bktReloadParams() {
    const { data } = await axios.post(`${baseUrl}/reload-params`, null, { timeout: 5000 });
    return data;
}
