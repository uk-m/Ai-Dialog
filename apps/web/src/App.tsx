import { BrowserRouter, Route, Routes } from "react-router-dom";
import { AppShell } from "./components/layout/AppShell";
import { TimelinePage } from "./pages/TimelinePage";
import { UploadPage } from "./pages/UploadPage";
import { CalendarPage } from "./pages/CalendarPage";
import { WeeklyPage } from "./pages/WeeklyPage";
import { SettingsPage } from "./pages/SettingsPage";
import { EntryDetailPage } from "./pages/EntryDetailPage";

const App = () => (
  <BrowserRouter>
    <AppShell>
      <Routes>
        <Route path="/" element={<TimelinePage />} />
        <Route path="/upload" element={<UploadPage />} />
        <Route path="/calendar" element={<CalendarPage />} />
        <Route path="/weekly" element={<WeeklyPage />} />
        <Route path="/settings" element={<SettingsPage />} />
        <Route path="/entries/:id" element={<EntryDetailPage />} />
      </Routes>
    </AppShell>
  </BrowserRouter>
);

export default App;
