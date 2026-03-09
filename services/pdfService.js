import axios from 'axios';
import FormData from 'form-data';

export async function extractTextFromPDF(fileBuffer, originalName) {
    const formData = new FormData();
    formData.append('file', fileBuffer, { filename: originalName, contentType: 'application/pdf' });

    const uploadResponse = await axios.post(
        'https://api.cloud.llamaindex.ai/api/v1/parsing/upload',
        formData,
        { headers: { 'accept': 'application/json', 'Authorization': `Bearer ${process.env.LLAMA_CLOUD_API_KEY}`, ...formData.getHeaders() } }
    );

    const jobId = uploadResponse.data.id;
    let done = false, attempts = 0;
    while (!done && attempts < 60) {
        const status = await axios.get(
            `https://api.cloud.llamaindex.ai/api/v1/parsing/job/${jobId}`,
            { headers: { 'accept': 'application/json', 'Authorization': `Bearer ${process.env.LLAMA_CLOUD_API_KEY}` } }
        );
        if (status.data.status === 'SUCCESS') done = true;
        else if (status.data.status === 'ERROR') throw new Error('PDF parsing failed');
        else { await new Promise(r => setTimeout(r, 2000)); attempts++; }
    }
    if (!done) throw new Error('PDF parsing timeout');

    const result = await axios.get(
        `https://api.cloud.llamaindex.ai/api/v1/parsing/job/${jobId}/result/markdown`,
        { headers: { 'accept': 'application/json', 'Authorization': `Bearer ${process.env.LLAMA_CLOUD_API_KEY}` } }
    );

    const text = result.data.markdown;
    if (!text || text.trim().length < 50) throw new Error('PDF content too short or empty');
    return text;
}
