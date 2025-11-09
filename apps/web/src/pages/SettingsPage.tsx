import { usePreferences } from "../hooks/usePreferences";
import { Label } from "../components/ui/label";
import { Switch } from "../components/ui/switch";
import { Input } from "../components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";

export const SettingsPage = () => {
  const { preferences, save } = usePreferences();

  return (
    <section className="space-y-6">
      <header>
        <h1 className="text-2xl font-semibold">ユーザー設定</h1>
        <p className="text-sm text-muted-foreground">テーマや週の開始曜日をカスタマイズできます。</p>
      </header>

      <Card>
        <CardHeader>
          <CardTitle>表示</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <Label>ダークモード</Label>
              <p className="text-sm text-muted-foreground">
                {preferences.theme === "dark" ? "オン" : "オフ"}
              </p>
            </div>
            <Switch
              checked={preferences.theme === "dark"}
              onClick={() =>
                save({ theme: preferences.theme === "dark" ? "light" : "dark" })
              }
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="week">週の開始曜日</Label>
            <select
              id="week"
              className="w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm"
              value={preferences.week_start}
              onChange={(event) => save({ week_start: event.target.value as "monday" | "sunday" })}
            >
              <option value="monday">月曜日</option>
              <option value="sunday">日曜日</option>
            </select>
          </div>
          <div className="space-y-2">
            <Label htmlFor="language">表示言語</Label>
            <Input
              id="language"
              value={preferences.language}
              onChange={(event) => save({ language: event.target.value })}
            />
          </div>
        </CardContent>
      </Card>
    </section>
  );
};
