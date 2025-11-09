import { useEffect, useState } from "react";
import { fetchCalendarHeatmap } from "../api/diary";

export const useCalendarHeatmap = () => {
  const [data, setData] = useState<Array<{ date: string; count: number }>>([]);

  useEffect(() => {
    const run = async () => {
      try {
        const response = await fetchCalendarHeatmap();
        setData(response);
      } catch (error) {
        console.error(error);
      }
    };
    run();
  }, []);

  return data;
};
