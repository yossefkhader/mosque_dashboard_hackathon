# Calendar Event Management

## Features

✅ **Load events from JSON file on app startup**
✅ **Add new events with a beautiful dialog**
✅ **Edit existing events by tapping on them**
✅ **Delete events with confirmation**
✅ **Persist events using browser storage**
✅ **Download backup as JSON file**
✅ **Drag and resize events**
✅ **Multiple color options for events**
✅ **Arabic interface with mosque-related sample events**

## How to Use

### 1. **Adding Events**
- Click the **+** button in the top-right corner
- Or tap on any empty calendar cell
- Fill in the event details (title is required)
- Choose a color and set time/date
- Click "إضافة" (Add) to save

### 2. **Editing Events**
- Tap on any existing event
- Modify the details in the dialog
- Click "حفظ" (Save) to update
- Or click "حذف" (Delete) to remove the event

### 3. **Event Features**
- **All-day events**: Toggle "طوال اليوم" switch
- **Color coding**: Choose from 6 different colors
- **Location**: Optional field for event location
- **Description**: Add detailed notes about the event

### 4. **Calendar Interactions**
- **Resize**: Drag event edges to change duration
- **Views**: Switch between Month, Week, Day, and Schedule views
- **Navigation**: Use arrow buttons or date picker to navigate

### 5. **Backup & Restore**
- Click the download icon to export events as JSON
- Events are automatically saved to browser storage
- Initial sample events are loaded from `lib/assets/events.json`

## Technical Details

- **Storage**: Uses `shared_preferences` for web storage
- **Format**: Events stored as JSON in browser localStorage
- **Fallback**: If localStorage fails, loads from assets
- **Web-only**: Optimized for Flutter web deployment

## Sample Events Included

The app comes with sample mosque-related events:
- صلاة الجمعة (Friday Prayer)
- درس تفسير القرآن (Quran Interpretation Class)
- حلقة تحفيظ القرآن للأطفال (Children's Quran Memorization)
- اجتماع اللجنة الإدارية (Administrative Committee Meeting)
- ليلة القدر (Laylat al-Qadr)
- عيد الفطر (Eid al-Fitr)

These serve as examples and can be edited or deleted as needed.
