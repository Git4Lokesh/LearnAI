import { ChatPerplexity } from "@langchain/community/chat_models/perplexity";
import { ChatPromptTemplate, MessagesPlaceholder } from "@langchain/core/prompts";
import { HumanMessage, AIMessage } from "@langchain/core/messages";
import dotenv from "dotenv";

dotenv.config();

const model = new ChatPerplexity({
    apiKey: process.env.PERPLEXITY_API_KEY,
    model: "sonar-pro",
    temperature: 0.7,
});

// Store conversation history per session (arrays of messages)
const conversationHistories = new Map();

export async function chatWithPerplexity(message, userId, sessionId = "default") {
    const memoryKey = `${userId}_${sessionId}`;
    
    // Get or create conversation history
    if (!conversationHistories.has(memoryKey)) {
        conversationHistories.set(memoryKey, []);
    }
    
    const history = conversationHistories.get(memoryKey);
    
    // Create prompt with MessagesPlaceholder
    const prompt = ChatPromptTemplate.fromMessages([
        {
            role: "system",
            content: "You are a helpful AI study assistant. Provide clear, concise, and educational responses to help students learn."
        },
        new MessagesPlaceholder("history"),
        {
            role: "user",
            content: "{input}"
        }
    ]);
    
    // Build the chain
    const chain = prompt.pipe(model);
    
    // Invoke with history
    const response = await chain.invoke({
        input: message,
        history: history
    });
    
    // Save user and assistant messages to history (using LangChain message classes)
    history.push(new HumanMessage(message));
    history.push(new AIMessage(response.content));
    
    return response.content;
}