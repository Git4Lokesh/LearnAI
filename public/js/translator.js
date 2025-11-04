/**
 * Translation Utility for Learn.ai
 * Translates all visible text on the page to the selected language
 */

class PageTranslator {
    constructor() {
        this.currentLanguage = localStorage.getItem('selectedLanguage') || 'en';
        this.translationCache = new Map();
        this.isTranslating = false;
        
        // Supported languages with their display names
        this.supportedLanguages = {
            'en': 'English',
            'es': 'Español',
            'fr': 'Français',
            'de': 'Deutsch',
            'it': 'Italiano',
            'pt': 'Português',
            'ru': 'Русский',
            'ja': '日本語',
            'ko': '한국어',
            'zh': '中文',
            'ar': 'العربية',
            'hi': 'हिन्दी',
            'nl': 'Nederlands',
            'pl': 'Polski',
            'tr': 'Türkçe'
        };
        
        this.init();
    }
    
    init() {
        // Load saved language preference and auto-translate on page load
        const savedLanguage = localStorage.getItem('selectedLanguage') || 'en';
        this.currentLanguage = savedLanguage;
        
        if (savedLanguage !== 'en') {
            // Wait for DOM to be fully loaded, then translate
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', () => {
                    setTimeout(() => {
                        this.translatePage(savedLanguage);
                    }, 800);
                });
            } else {
                // DOM already loaded
                setTimeout(() => {
                    this.translatePage(savedLanguage);
                }, 800);
            }
        }
    }
    
    /**
     * Get all translatable text elements from the page
     */
    getTranslatableElements() {
        const selectors = [
            'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
            'p', 'span', 'div', 'label', 'a', 'button',
            'td', 'th', 'li', 'small', 'strong', 'em'
        ];
        
        const elements = [];
        const skipClasses = ['math-equation', 'no-translate', 'translated'];
        const skipAttributes = ['data-no-translate', 'data-translated'];
        
        selectors.forEach(selector => {
            document.querySelectorAll(selector).forEach(el => {
                // Skip if element has skip class or attribute
                if (skipClasses.some(cls => el.classList.contains(cls))) return;
                if (skipAttributes.some(attr => el.hasAttribute(attr))) return;
                
                // Skip if element is inside a skip container
                if (el.closest('.no-translate')) return;
                
                // Get text content
                const text = this.getTextContent(el);
                if (text && text.trim().length > 0) {
                    // Skip if it's just whitespace or very long (likely code/generated content)
                    if (text.trim().length > 500) return;
                    
                    elements.push({
                        element: el,
                        originalText: text,
                        textKey: this.generateTextKey(text)
                    });
                }
            });
        });
        
        return elements;
    }
    
    /**
     * Get clean text content from an element
     */
    getTextContent(element) {
        // Skip if element has children that are also translatable
        const children = Array.from(element.children);
        if (children.length > 0) {
            // If element has direct text, return it
            const directText = Array.from(element.childNodes)
                .filter(node => node.nodeType === Node.TEXT_NODE)
                .map(node => node.textContent.trim())
                .join(' ')
                .trim();
            
            return directText || null;
        }
        
        return element.textContent.trim();
    }
    
    /**
     * Generate a key for caching translations
     */
    generateTextKey(text) {
        return text.toLowerCase().trim().substring(0, 50);
    }
    
    /**
     * Translate a single text element
     */
    async translateElement(element, originalText, targetLanguage) {
        try {
            // Check cache first
            const cacheKey = `${originalText}|${targetLanguage}`;
            if (this.translationCache.has(cacheKey)) {
                return this.translationCache.get(cacheKey);
            }
            
            // Call translation API
            const response = await fetch('/api/translate', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    text: originalText,
                    targetLanguage: targetLanguage,
                    sourceLanguage: 'en'
                })
            });
            
            if (!response.ok) {
                throw new Error('Translation API failed');
            }
            
            const data = await response.json();
            const translatedText = data.translatedText || originalText;
            
            // Cache the translation
            this.translationCache.set(cacheKey, translatedText);
            
            return translatedText;
        } catch (error) {
            console.error('Translation error:', error);
            return originalText; // Return original on error
        }
    }
    
    /**
     * Translate the entire page
     */
    async translatePage(targetLanguage) {
        if (this.isTranslating) {
            console.log('Translation already in progress');
            return;
        }
        
        if (targetLanguage === 'en') {
            this.restoreOriginalPage();
            return;
        }
        
        this.isTranslating = true;
        const elements = this.getTranslatableElements();
        
        // Show loading indicator
        this.showTranslationIndicator();
        
        try {
            // Translate in batches to avoid overwhelming the API
            const batchSize = 10;
            for (let i = 0; i < elements.length; i += batchSize) {
                const batch = elements.slice(i, i + batchSize);
                
                // Translate batch
                const translations = await Promise.all(
                    batch.map(item => 
                        this.translateElement(item.element, item.originalText, targetLanguage)
                    )
                );
                
                // Update elements with translations
                batch.forEach((item, index) => {
                    const translatedText = translations[index];
                    if (translatedText && translatedText !== item.originalText) {
                        this.updateElementText(item.element, item.originalText, translatedText);
                    }
                });
                
                // Small delay between batches
                await new Promise(resolve => setTimeout(resolve, 100));
            }
            
            this.currentLanguage = targetLanguage;
            localStorage.setItem('selectedLanguage', targetLanguage);
            
        } catch (error) {
            console.error('Page translation error:', error);
        } finally {
            this.isTranslating = false;
            this.hideTranslationIndicator();
        }
    }
    
    /**
     * Update element text while preserving structure
     */
    updateElementText(element, originalText, translatedText) {
        // Store original text if not already stored
        if (!element.dataset.originalText) {
            element.dataset.originalText = originalText;
        }
        
        // Update text content
        if (element.childNodes.length === 0) {
            element.textContent = translatedText;
        } else {
            // Replace first text node
            const firstTextNode = Array.from(element.childNodes).find(
                node => node.nodeType === Node.TEXT_NODE
            );
            if (firstTextNode) {
                firstTextNode.textContent = translatedText;
            }
        }
        
        // Mark as translated
        element.classList.add('translated');
        element.setAttribute('data-translated', 'true');
    }
    
    /**
     * Restore original page text
     */
    restoreOriginalPage() {
        const translatedElements = document.querySelectorAll('[data-translated="true"]');
        translatedElements.forEach(el => {
            const originalText = el.dataset.originalText;
            if (originalText) {
                if (el.childNodes.length === 0) {
                    el.textContent = originalText;
                } else {
                    const firstTextNode = Array.from(el.childNodes).find(
                        node => node.nodeType === Node.TEXT_NODE
                    );
                    if (firstTextNode) {
                        firstTextNode.textContent = originalText;
                    }
                }
                el.removeAttribute('data-translated');
                el.classList.remove('translated');
                delete el.dataset.originalText;
            }
        });
        
        this.currentLanguage = 'en';
        localStorage.setItem('selectedLanguage', 'en');
    }
    
    /**
     * Show translation loading indicator
     */
    showTranslationIndicator() {
        let indicator = document.getElementById('translation-indicator');
        if (!indicator) {
            indicator = document.createElement('div');
            indicator.id = 'translation-indicator';
            indicator.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: rgba(124, 58, 237, 0.9);
                color: white;
                padding: 12px 20px;
                border-radius: 8px;
                z-index: 10000;
                font-size: 14px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            `;
            indicator.innerHTML = '<i class="bi bi-translate"></i> Translating...';
            document.body.appendChild(indicator);
        }
        indicator.style.display = 'block';
    }
    
    /**
     * Hide translation loading indicator
     */
    hideTranslationIndicator() {
        const indicator = document.getElementById('translation-indicator');
        if (indicator) {
            indicator.style.display = 'none';
        }
    }
    
    /**
     * Change language
     */
    async changeLanguage(languageCode) {
        if (this.currentLanguage === languageCode) {
            return;
        }
        
        await this.translatePage(languageCode);
        
        // Update language selector if it exists
        const selector = document.getElementById('language-selector');
        if (selector) {
            selector.value = languageCode;
        }
    }
    
    /**
     * Get current language
     */
    getCurrentLanguage() {
        return this.currentLanguage;
    }
    
    /**
     * Get supported languages
     */
    getSupportedLanguages() {
        return this.supportedLanguages;
    }
}

// Initialize translator when DOM is ready
let translator;
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        translator = new PageTranslator();
        window.translator = translator; // Make it globally accessible
    });
} else {
    translator = new PageTranslator();
    window.translator = translator;
}

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = PageTranslator;
}

