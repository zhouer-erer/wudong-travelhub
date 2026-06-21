/**
 * 防重复提交 Hook
 * 在表单提交期间锁定按钮，防止用户连续快速点击导致重复提交
 *
 * 用法：
 *   const { locked, wrapSubmit } = useSubmitLock();
 *   const handleSubmit = wrapSubmit(async () => { await request.post(...) });
 *   <Button loading={locked} onClick={handleSubmit}>提交</Button>
 */
import { useState, useCallback, useRef } from 'react';

export function useSubmitLock() {
  const [locked, setLocked] = useState(false);
  const lockedRef = useRef(false);

  /**
   * 包装一个异步函数，执行期间自动加锁/解锁
   * @param fn 需要防重复提交的异步函数
   * @returns 包装后的函数
   */
  const wrapSubmit = useCallback(<T extends (...args: any[]) => Promise<any>>(fn: T) => {
    return async (...args: Parameters<T>): Promise<ReturnType<T> | undefined> => {
      if (lockedRef.current) return undefined;
      lockedRef.current = true;
      setLocked(true);
      try {
        return await fn(...args);
      } finally {
        lockedRef.current = false;
        setLocked(false);
      }
    };
  }, []);

  return { locked, wrapSubmit };
}
