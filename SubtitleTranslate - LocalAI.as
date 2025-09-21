/*
    Real-time subtitle translation for PotPlayer using Local AI API
*/

string GetTitle() {
    return "{$CP949=로컬 AI 번역$}{$CP950=本地 AI 翻譯$}{$CP0=Local AI translate$}";
}

string GetVersion() {
    return "1.1";
}

string GetDesc() {
    return "https://localhost:12340/";
}

string GetLoginTitle() {
    return "Input Local AI Model Name and API URL";
}

string GetLoginDesc() {
    return "Input Local AI Model Name and API URL";
}

string GetUserText() {
    return "Model Name|API URL:";
}

string GetPasswordText() {
    return "API Key:";
}

string model_name = "qwen3-4b-instruct-2507";
string api_url = "http://localhost:12340/v1/chat/completions";
string api_key = "";
string UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36";

string ServerLogin(string User, string Pass) {
    // Parse User input (ModelName|API_URL)
    array<string> parts = User.split("|");
    if (parts.length() >= 1 && !parts[0].empty()) {
        model_name = parts[0].Trim();
    }
    if (parts.length() >= 2 && !parts[1].empty()) {
        api_url = parts[1].Trim();
    }
    
    api_key = Pass.Trim();
    
    // Save settings
    HostSaveString("localai_model_name", model_name);
    HostSaveString("localai_api_url", api_url);
    HostSaveString("localai_api_key", api_key);
    
    if (model_name.empty()) return "fail";
    return "200 ok";
}

void ServerLogout() {
    model_name = "qwen3-4b-instruct-2507";
    api_url = "http://localhost:12340/v1/chat/completions";
    api_key = "";
    HostSaveString("localai_model_name", model_name);
    HostSaveString("localai_api_url", api_url);
    HostSaveString("localai_api_key", api_key);
}

array<string> LangTable = 
{
    "af", "sq", "am", "ar", "hy", "az", "eu", "be", "bn", "bs", "bg", "ca",
    "ceb", "ny", "zh-CN", "zh-TW", "co", "hr", "cs", "da", "nl", "en", "eo",
    "et", "tl", "fi", "fr", "fy", "gl", "ka", "de", "el", "gu", "ht", "ha",
    "haw", "he", "hi", "hmn", "hu", "is", "ig", "id", "ga", "it", "ja", "jw",
    "kn", "kk", "km", "ko", "ku", "ky", "lo", "la", "lv", "lt", "lb", "mk",
    "ms", "mg", "ml", "mt", "mi", "mr", "mn", "my", "ne", "no", "ps", "fa",
    "pl", "pt", "pa", "ro", "ru", "sm", "gd", "sr", "st", "sn", "sd", "si",
    "sk", "sl", "so", "es", "su", "sw", "sv", "tg", "ta", "te", "th", "tr",
    "uk", "ur", "uz", "vi", "cy", "xh", "yi", "yo", "zu"
};

array<string> GetSrcLangs() {
    array<string> ret = LangTable;
    ret.insertAt(0, ""); // empty is auto
    return ret;
}

array<string> GetDstLangs() {
    array<string> ret = LangTable;
    return ret;
}

string JsonEscape(const string &in input) {
    string output = input;
    output.replace("\\", "\\\\");
    output.replace("\"", "\\\"");
    output.replace("\n", "\\n");
    output.replace("\r", "\\r");
    output.replace("\t", "\\t");
    return output;
}

string JsonParse(string json) {
    JsonReader Reader;
    JsonValue Root;
    string ret = "";

    if (Reader.parse(json, Root) && Root.isObject()) {
        JsonValue choices = Root["choices"];
        if (choices.isArray() && choices.size() > 0) {
            JsonValue message = choices[0]["message"];
            if (message.isObject() && message["content"].isString()) {
                ret = message["content"].asString();
            }
        }
    }
    return ret;
}

string Translate(string Text, string &in SrcLang, string &in DstLang) {
    // Load settings
    model_name = HostLoadString("localai_model_name", "qwen3-4b-instruct-2507");
    api_url = HostLoadString("localai_api_url", "http://localhost:12340/v1/chat/completions");
    api_key = HostLoadString("localai_api_key", "");

    string UNICODE_RLE = "\u202B";
    
    if (SrcLang.length() <= 0) SrcLang = "auto";
    SrcLang.MakeLower();
    
    // Build prompt with translation expert instruction
    string expertInstruction = "You are a professional translator. Please translate the following text accurately while preserving the original meaning, tone, and context. Ensure the translation is natural and fluent in the target language.";
    string translationRequest = "Translate from " + SrcLang + " to " + DstLang + ": " + Text;
    
    // JSON escape
    string escapedExpertInstruction = JsonEscape(expertInstruction);
    string escapedTranslationRequest = JsonEscape(translationRequest);
    
    // Build request data with system message and user message using a cleaner approach
    string requestData = "{\"model\":\"" + model_name + "\",\"messages\":[{\"role\":\"system\",\"content\":\"" + escapedExpertInstruction + "\"},{\"role\":\"user\",\"content\":\"" + escapedTranslationRequest + "\"}],\"temperature\":0.5}";
    
    string headers = "Content-Type: application/json";
    if (!api_key.empty()) {
        headers = "Authorization: Bearer " + api_key + "\n" + headers;
    }
    
    // Send request
    string response = HostUrlGetString(api_url, UserAgent, headers, requestData);
    
    // Parse response
    string translatedText = JsonParse(response);
    if (translatedText.empty()) {
        return "";
    }
    
    if (DstLang == "fa" || DstLang == "ar" || DstLang == "he") {
        translatedText = UNICODE_RLE + translatedText;
    }
    
    SrcLang = "UTF8";
    DstLang = "UTF8";
    return translatedText;
}

void OnInitialize() {
    // Load settings
    model_name = HostLoadString("localai_model_name", "qwen3-4b-instruct-2507");
    api_url = HostLoadString("localai_api_url", "http://localhost:12340/v1/chat/completions");
    api_key = HostLoadString("localai_api_key", "");
}