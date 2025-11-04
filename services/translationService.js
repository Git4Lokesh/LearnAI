import axios from 'axios';
import dotenv from 'dotenv';

dotenv.config();

/**
 * Translate text using Google Translate API
 * @param {string} text - Text to translate
 * @param {string} targetLanguage - Target language code (e.g., 'es', 'fr', 'de')
 * @param {string} sourceLanguage - Source language code (default: 'en')
 * @returns {Promise<string>} - Translated text
 */
export async function translateText(text, targetLanguage, sourceLanguage = 'en') {
    try {
        // If target language is the same as source, return original text
        if (targetLanguage === sourceLanguage || !targetLanguage || targetLanguage === 'en') {
            return text;
        }

        // If no API key, use free alternative (Google Translate unofficial API)
        if (!process.env.GOOGLE_TRANSLATE_API_KEY) {
            return await translateTextFree(text, targetLanguage, sourceLanguage);
        }

        // Use official Google Translate API
        const apiKey = process.env.GOOGLE_TRANSLATE_API_KEY;
        const url = `https://translation.googleapis.com/language/translate/v2?key=${apiKey}`;
        
        const response = await axios.post(url, {
            q: text,
            target: targetLanguage,
            source: sourceLanguage,
            format: 'text'
        });

        if (response.data && response.data.data && response.data.data.translations) {
            return response.data.data.translations[0].translatedText;
        }
        
        throw new Error('Invalid response from Google Translate API');
    } catch (error) {
        console.error('Translation error:', error.message);
        // Fallback to free translation service
        return await translateTextFree(text, targetLanguage, sourceLanguage);
    }
}

/**
 * Free translation alternative using unofficial API
 * @param {string} text - Text to translate
 * @param {string} targetLanguage - Target language code
 * @param {string} sourceLanguage - Source language code
 * @returns {Promise<string>} - Translated text
 */
async function translateTextFree(text, targetLanguage, sourceLanguage = 'en') {
    try {
        // Using a free translation service (you can replace with any free API)
        const response = await axios.get('https://api.mymemory.translated.net/get', {
            params: {
                q: text,
                langpair: `${sourceLanguage}|${targetLanguage}`
            }
        });

        if (response.data && response.data.responseData && response.data.responseData.translatedText) {
            return response.data.responseData.translatedText;
        }
        
        throw new Error('Translation service unavailable');
    } catch (error) {
        console.error('Free translation error:', error.message);
        // Return original text if translation fails
        return text;
    }
}

/**
 * Translate multiple texts at once
 * @param {string[]} texts - Array of texts to translate
 * @param {string} targetLanguage - Target language code
 * @param {string} sourceLanguage - Source language code
 * @returns {Promise<string[]>} - Array of translated texts
 */
export async function translateMultiple(texts, targetLanguage, sourceLanguage = 'en') {
    try {
        const translations = await Promise.all(
            texts.map(text => translateText(text, targetLanguage, sourceLanguage))
        );
        return translations;
    } catch (error) {
        console.error('Batch translation error:', error);
        return texts; // Return original texts on error
    }
}

