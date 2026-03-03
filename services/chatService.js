import { GoogleGenerativeAI } from '@google/generative-ai';
import { RecursiveCharacterTextSplitter } from '@langchain/textsplitters';
import { MemoryVectorStore } from 'langchain/vectorstores/memory';
import { HuggingFaceTransformersEmbeddings } from '@langchain/community/embeddings/hf_transformers';
import { extractTextFromPDF } from './pdfService.js';
import dotenv from 'dotenv';
dotenv.config();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const conversationHistories = new Map();
const sessionVectorStores = new Map();

const embeddings = new HuggingFaceTransformersEmbeddings({ model: 'Xenova/all-MiniLM-L6-v2' });
const splitter = new RecursiveCharacterTextSplitter({ chunkSize: 500, chunkOverlap: 50 });

export async function ingestPDFForSession(fileBuffer, originalName, userId, sessionId) {
    const text = await extractTextFromPDF(fileBuffer, originalName);
    const docs = await splitter.createDocuments([text]);
    const store = await MemoryVectorStore.fromDocuments(docs, embeddings);
    sessionVectorStores.set(`${userId}_${sessionId}`, store);
    return docs.length;
}

export async function chatWithPerplexityStream(message, userId, sessionId = 'default', res) {
    const memoryKey = `${userId}_${sessionId}`;
    if (!conversationHistories.has(memoryKey)) conversationHistories.set(memoryKey, []);
    const history = conversationHistories.get(memoryKey);

    let contextBlock = '';
    const store = sessionVectorStores.get(memoryKey);
    if (store) {
        const docs = await store.similaritySearch(message, 4);
        if (docs.length > 0) contextBlock = `\n\nRelevant context from uploaded document:\n${docs.map(d => d.pageContent).join('\n---\n')}\n`;
    }

    const model = genAI.getGenerativeModel({
        model: 'gemini-1.5-flash',
        systemInstruction: `You are a helpful AI study assistant. Provide clear, concise, and educational responses to help students learn.${contextBlock}`
    });

    const geminiHistory = history.map(m => ({
        role: m.role === 'assistant' ? 'model' : 'user',
        parts: [{ text: m.content }]
    }));

    const chat = model.startChat({ history: geminiHistory });

    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    const result = await chat.sendMessageStream(message);
    let fullContent = '';

    for await (const chunk of result.stream) {
        const token = chunk.text();
        if (token) {
            fullContent += token;
            res.write(`data: ${JSON.stringify({ token })}\n\n`);
        }
    }

    res.write('data: [DONE]\n\n');
    history.push({ role: 'user', content: message });
    history.push({ role: 'assistant', content: fullContent });
    res.end();
}

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

    const model = genAI.getGenerativeModel({
        model: 'gemini-1.5-flash',
        systemInstruction: `You are a helpful AI study assistant.${contextBlock}`
    });

    const geminiHistory = history.map(m => ({
        role: m.role === 'assistant' ? 'model' : 'user',
        parts: [{ text: m.content }]
    }));

    const chat = model.startChat({ history: geminiHistory });
    const result = await chat.sendMessage(message);
    const content = result.response.text();

    history.push({ role: 'user', content: message });
    history.push({ role: 'assistant', content });
    return content;
}
