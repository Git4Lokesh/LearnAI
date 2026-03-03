import axios from 'axios';
import { RecursiveCharacterTextSplitter } from '@langchain/textsplitters';
import { MemoryVectorStore } from 'langchain/vectorstores/memory';
import { HuggingFaceTransformersEmbeddings } from '@langchain/community/embeddings/hf_transformers';
import { extractTextFromPDF } from './pdfService.js';
import dotenv from 'dotenv';
dotenv.config();

const conversationHistories = new Map();
// Per-session vector stores: Map<sessionKey, MemoryVectorStore>
const sessionVectorStores = new Map();

const embeddings = new HuggingFaceTransformersEmbeddings({
    model: 'Xenova/all-MiniLM-L6-v2',
});

const splitter = new RecursiveCharacterTextSplitter({ chunkSize: 500, chunkOverlap: 50 });

export async function ingestPDFForSession(fileBuffer, originalName, userId, sessionId) {
    const text = await extractTextFromPDF(fileBuffer, originalName);
    const docs = await splitter.createDocuments([text]);
    const store = await MemoryVectorStore.fromDocuments(docs, embeddings);
    sessionVectorStores.set(`${userId}_${sessionId}`, store);
    return docs.length;
}

// Streaming version — writes SSE chunks to res
export async function chatWithPerplexityStream(message, userId, sessionId = 'default', res) {
    const memoryKey = `${userId}_${sessionId}`;
    if (!conversationHistories.has(memoryKey)) conversationHistories.set(memoryKey, []);
    const history = conversationHistories.get(memoryKey);

    // RAG: retrieve relevant context if a vector store exists for this session
    let contextBlock = '';
    const store = sessionVectorStores.get(memoryKey);
    if (store) {
        const docs = await store.similaritySearch(message, 4);
        if (docs.length > 0) {
            contextBlock = `\n\nRelevant context from uploaded document:\n${docs.map(d => d.pageContent).join('\n---\n')}\n`;
        }
    }

    const systemContent = `You are a helpful AI study assistant. Provide clear, concise, and educational responses to help students learn.${contextBlock}`;

    const messages = [
        { role: 'system', content: systemContent },
        ...history,
        { role: 'user', content: message }
    ];

    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    const response = await axios.post('https://api.perplexity.ai/chat/completions', {
        model: 'sonar-pro',
        messages,
        stream: true,
    }, {
        headers: { Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}` },
        responseType: 'stream',
    });

    let fullContent = '';
    response.data.on('data', (chunk) => {
        const lines = chunk.toString().split('\n').filter(l => l.startsWith('data: '));
        for (const line of lines) {
            const data = line.slice(6).trim();
            if (data === '[DONE]') { res.write('data: [DONE]\n\n'); return; }
            try {
                const parsed = JSON.parse(data);
                const token = parsed.choices?.[0]?.delta?.content;
                if (token) {
                    fullContent += token;
                    res.write(`data: ${JSON.stringify({ token })}\n\n`);
                }
            } catch { /* skip malformed chunks */ }
        }
    });

    response.data.on('end', () => {
        history.push({ role: 'user', content: message });
        history.push({ role: 'assistant', content: fullContent });
        res.end();
    });

    response.data.on('error', (err) => {
        console.error('Stream error:', err);
        res.end();
    });
}

// Non-streaming fallback (kept for backward compatibility)
export async function chatWithPerplexity(message, userId, sessionId = 'default') {
    const memoryKey = `${userId}_${sessionId}`;
    if (!conversationHistories.has(memoryKey)) conversationHistories.set(memoryKey, []);
    const history = conversationHistories.get(memoryKey);

    let contextBlock = '';
    const store = sessionVectorStores.get(memoryKey);
    if (store) {
        const docs = await store.similaritySearch(message, 4);
        if (docs.length > 0) contextBlock = `\n\nRelevant context from uploaded document:\n${docs.map(d => d.pageContent).join('\n---\n')}\n`;
    }

    const response = await axios.post('https://api.perplexity.ai/chat/completions', {
        model: 'sonar-pro',
        messages: [
            { role: 'system', content: `You are a helpful AI study assistant.${contextBlock}` },
            ...history,
            { role: 'user', content: message }
        ],
    }, { headers: { Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}` } });

    const content = response.data.choices[0].message.content;
    history.push({ role: 'user', content: message });
    history.push({ role: 'assistant', content });
    return content;
}
