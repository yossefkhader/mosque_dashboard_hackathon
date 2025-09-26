# OpenAI Integration Setup Guide

## Overview

Your mosque dashboard now includes intelligent AI-powered chat assistance using OpenAI's GPT models. The AI can understand mosque-specific context and provide personalized recommendations for events, programs, and planning.

## Features

### 🤖 **Smart AI Responses**
- **Context-Aware**: Uses mosque information from settings
- **Event Generation**: Creates detailed event proposals with dates, times, and locations
- **Text Responses**: Provides advice, explanations, and guidance
- **Multilingual**: Fully supports Arabic language

### 📊 **Context Integration**
The AI uses three main sources of context:
1. **Mosque Context**: Information from settings (priorities, audiences, capacity, special needs)
2. **AI Context**: General instructions for mosque management (from `ai_context.txt`)
3. **Existing Events**: Current calendar events to avoid conflicts

### 🎯 **Response Types**
- **Event Proposals**: JSON-formatted event lists with approval/rejection workflow
- **Text Advice**: General guidance and recommendations
- **Error Handling**: Graceful fallbacks and informative error messages

## Setup Instructions

### Step 1: Get OpenAI API Key

1. Visit [OpenAI Platform](https://platform.openai.com/)
2. Sign up or log in to your account
3. Navigate to API Keys section
4. Click "Create new secret key"
5. Copy the generated key (starts with `sk-`)

### Step 2: Configure the API Key

1. Open `lib/services/openai_service.dart`
2. Find the line: `static const String _apiKey = 'YOUR_OPENAI_API_KEY_HERE';`
3. Replace `YOUR_OPENAI_API_KEY_HERE` with your actual OpenAI API key
4. Save the file

```dart
// Example:
static const String _apiKey = 'sk-proj-abcd1234...your-actual-key-here';
```

### Step 3: Test the Integration

1. Run your app
2. Go to Settings page - you should see "AI Connected" status
3. Navigate to AI Chat page
4. Try sending a message like: "اقترح برنامج للأطفال"
5. The AI should respond with personalized event suggestions

## Usage Examples

### Basic Queries
- `اقترح برنامج شهري للمسجد` - Monthly program suggestions
- `ما هي أفضل الفعاليات لرمضان؟` - Ramadan event ideas
- `كيف أنظم مسابقة قرآنية؟` - Quran competition guidance

### Context-Aware Requests
- `برنامج للأطفال` - Children's program (uses audience info from settings)
- `فعاليات تناسب السعة لدينا` - Events matching mosque capacity
- `برنامج يراعي الاحتياجات الخاصة` - Special needs considerations

### Event Generation
When asking for specific programs or events, the AI will:
1. Generate detailed event proposals
2. Show preview with titles, descriptions, dates, locations
3. Allow bulk approval/rejection
4. Automatically add approved events to calendar

## Configuration Options

### Model Settings
In `openai_service.dart`, you can adjust:

```dart
static const String _model = 'gpt-3.5-turbo'; // or 'gpt-4' for better quality
```

### Response Limits
```dart
'max_tokens': 2000, // Adjust response length
'temperature': 0.7, // Creativity level (0.0-1.0)
```

### Context Files

#### `lib/assets/ai_context.txt`
General instructions for the AI about mosque management, response format, and guidelines.

#### Mosque Context (from Settings)
User-provided information about:
- Mosque priorities
- Target audiences  
- Special needs requirements
- Capacity and facilities
- Additional notes

## Troubleshooting

### ❌ **AI Not Connected**
- Check API key is correctly set in `openai_service.dart`
- Verify API key is valid and has credits
- Ensure internet connection is stable

### ❌ **No Response or Errors**
- Check API quotas and billing in OpenAI dashboard
- Verify model name is correct (`gpt-3.5-turbo` or `gpt-4`)
- Check console logs for detailed error messages

### ❌ **Poor Quality Responses**
- Fill out mosque settings completely for better context
- Try different models (`gpt-4` for better quality)
- Adjust temperature settings
- Refine `ai_context.txt` instructions

### ❌ **Event Format Issues**
- The AI is instructed to return proper JSON format
- Check that `ai_context.txt` contains correct format instructions
- Verify event parsing logic in `_parseAIResponse` method

## Security Considerations

### 🔒 **API Key Security**
- Never commit API keys to version control
- Consider using environment variables or secure storage
- Implement API key rotation policies
- Monitor usage in OpenAI dashboard

### 🔒 **User Data**
- Mosque context data stays local (SharedPreferences)
- Only necessary context is sent to OpenAI
- No personal user information is transmitted

## Cost Management

### 💰 **Token Usage**
- Context preparation: ~500-1000 tokens per request
- User messages: Varies by length
- AI responses: 500-2000 tokens typically
- Total cost: ~$0.002-0.01 per conversation

### 💰 **Optimization Tips**
- Use `gpt-3.5-turbo` for cost efficiency
- Limit context to essential information only
- Implement response caching for common queries
- Set reasonable token limits

## Advanced Features

### 🔧 **Custom Instructions**
Modify `ai_context.txt` to:
- Add specific mosque traditions
- Include local cultural considerations
- Customize response tone and style
- Add domain-specific knowledge

### 🔧 **Response Processing**
The AI can return:
- Plain text responses for advice/guidance
- Structured event data for calendar integration
- Mixed responses with both text and events

### 🔧 **Context Enhancement**
Future improvements could include:
- Weather integration for outdoor events
- Holiday calendar integration
- Budget tracking and suggestions
- Attendance history analysis

## Support

For technical issues:
1. Check OpenAI platform status
2. Verify API key and billing
3. Review console logs for errors
4. Test with simple queries first

The AI integration provides a powerful foundation for intelligent mosque management assistance!
