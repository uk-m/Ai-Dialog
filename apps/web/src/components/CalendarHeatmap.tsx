import dayjs from "dayjs";

type Props = {
  data: Array<{ date: string; count: number }>;
};

export const CalendarHeatmap = ({ data }: Props) => {
  const byDate = new Map(data.map((item) => [item.date, item.count]));
  const today = dayjs();
  const days = Array.from({ length: 90 }).map((_, index) => today.subtract(index, "day")).reverse();

  const intensity = (count = 0) => {
    if (count === 0) return "bg-muted";
    if (count === 1) return "bg-green-200";
    if (count === 2) return "bg-green-400";
    return "bg-green-600 text-white";
  };

  return (
    <div className="grid gap-1" style={{ gridTemplateColumns: "repeat(15, minmax(0, 1fr))" }}>
      {days.map((day) => {
        const key = day.format("YYYY-MM-DD");
        const count = byDate.get(key) ?? 0;
        return (
          <div
            key={key}
            className={`h-6 w-6 rounded ${intensity(count)} text-center text-[10px] leading-6`}
            title={`${key}: ${count}件`}
          >
            {count > 0 ? count : ""}
          </div>
        );
      })}
    </div>
  );
};
