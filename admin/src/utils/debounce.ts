/**
 * 通用防抖工具
 * 用于搜索框输入、窗口 resize 等高频事件的节流
 */
import { useRef, useCallback } from 'react';

/**
 * React Hook 版防抖
 * @param fn 需要防抖的函数
 * @param delay 延迟毫秒数，默认 300ms
 * @returns 防抖后的函数引用（稳定不变）
 */
export function useDebouncedCallback<T extends (...args: any[]) => any>(fn: T, delay = 300) {
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const fnRef = useRef(fn);
  fnRef.current = fn;

  return useCallback((...args: Parameters<T>) => {
    if (timerRef.current) clearTimeout(timerRef.current);
    timerRef.current = setTimeout(() => fnRef.current(...args), delay);
  }, [delay]);
}

/**
 * 普通函数版防抖
 * @param fn 需要防抖的函数
 * @param delay 延迟毫秒数，默认 300ms
 */
export function debounce<T extends (...args: any[]) => any>(fn: T, delay = 300) {
  let timer: ReturnType<typeof setTimeout> | null = null;
  return (...args: Parameters<T>) => {
    if (timer) clearTimeout(timer);
    timer = setTimeout(() => fn(...args), delay);
  };
}
