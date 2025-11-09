import { Link, NavLink } from "react-router-dom";
import { Moon, Sun } from "lucide-react";
import { usePreferences } from "../../hooks/usePreferences";
import { APP_NAME } from "../../config";
import { Button } from "../ui/button";
import { useEffect } from "react";

const navItems = [
  { to: "/", label: "タイムライン" },
  { to: "/calendar", label: "カレンダー" },
  { to: "/upload", label: "アップロード" },
  { to: "/weekly", label: "週次まとめ" },
  { to: "/settings", label: "設定" },
];

export const AppShell = ({ children }: { children: React.ReactNode }) => {
  const { preferences, save } = usePreferences();

  useEffect(() => {
    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
    const shouldUseDark = preferences.theme === "dark" || (preferences.theme === "system" && prefersDark);
    document.documentElement.classList.toggle("dark", shouldUseDark);
  }, [preferences.theme]);

  const toggleTheme = () => {
    const next = preferences.theme === "dark" ? "light" : "dark";
    document.documentElement.classList.toggle("dark", next === "dark");
    save({ theme: next });
  };

  return (
    <div className="min-h-screen bg-background text-foreground">
      <header className="border-b bg-card">
        <div className="container flex items-center justify-between py-4">
          <Link to="/" className="text-xl font-semibold">
            {APP_NAME}
          </Link>
          <nav className="flex items-center gap-4 text-sm font-medium">
            {navItems.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                className={({ isActive }) =>
                  `transition hover:text-primary ${isActive ? "text-primary" : "text-muted-foreground"}`
                }
              >
                {item.label}
              </NavLink>
            ))}
            <Button variant="ghost" size="icon" onClick={toggleTheme} aria-label="テーマ切替">
              {preferences.theme === "dark" ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
            </Button>
          </nav>
        </div>
      </header>
      <main className="container py-6">{children}</main>
    </div>
  );
};
