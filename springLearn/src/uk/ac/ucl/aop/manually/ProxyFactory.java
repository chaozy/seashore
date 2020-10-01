package uk.ac.ucl.aop.manually;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * Manually created factory for proxy.
 * Could be ignored if Spring is used
 */
public class ProxyFactory {
    private static Object target;
    // classes needed by advice
    private static AOP aop;
    public static Object getProxyInstance(Object object, AOP aop_) {
        target = object;
        aop = aop_;

        return Proxy.newProxyInstance(target.getClass().getClassLoader(),
                target.getClass().getInterfaces(),
                new InvocationHandler(){
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        aop.begin();
                        Object returnValue = method.invoke(target, args);
                        aop.end();
                        return returnValue;
                    }
                });

    }
}
