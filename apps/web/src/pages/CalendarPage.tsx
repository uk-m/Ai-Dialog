import { CalendarHeatmap } from "../components/CalendarHeatmap";
import { useCalendarHeatmap } from "../hooks/useCalendarHeatmap";

export const CalendarPage = () => {
  const data = useCalendarHeatmap();

  return (
    <section className="space-y-6">
      <header>
        <h1 className="text-2xl font-semibold">カレンダー</h1>
        <p className="text-sm text-muted-foreground">直近 3 か月間の投稿状況をヒートマップで表示します。</p>
      </header>
      <CalendarHeatmap data={data} />
    </section>
  );
};
