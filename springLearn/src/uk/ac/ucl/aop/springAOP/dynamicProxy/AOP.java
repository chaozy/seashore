package uk.ac.ucl.aop.springAOP.dynamicProxy;

import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class AOP {
    @Pointcut("execution(* uk.ac.ucl.aop.springAOP.*.*.*(..))")
    public void point() {}

    @Before("execution(* uk.ac.ucl.aop.springAOP.*.*.*(..))")
    public void begin() {
        System.out.println("Event begins......");
    }
    @After("execution(* uk.ac.ucl.aop.springAOP.*.*.*(..))")
    public void end() {
        System.out.println("Event finishes....");
    }
}
