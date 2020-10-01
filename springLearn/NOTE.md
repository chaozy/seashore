# Spring Core #

## Basic ##

#### What is Spring ###

[Spring framework ](https://www.java2blog.com/2012/08/introduction-to-spring-framework.html)is an open source framework created to solve the complexity of enterprise application development. One of the chief advantages of the Spring framework is its layered architecture, which allows you to be selective about which of its components you use. Main module for Spring are Spring core,Spring AOP and Spring MVC.

#### Main features ####

- **Lightweight:**

  spring is lightweight when it comes to size and transparency. The basic version of spring framework is around 1MB. And the processing overhead is also very negligible.

- **Inversion of control (IOC):**

  The basic concept of the Dependency Injection or Inversion of Control is that, programmer do not need to create the objects, instead just describe how it should be created.

- **Aspect oriented (AOP):** 

  Spring supports Aspect oriented programming .

  [Aspect oriented programming](https://www.java2blog.com/2016/07/spring-aop-tutorial.html) refers to the programming paradigm which isolates secondary or supporting functions from the main program’s business logic. AOP is a promising technology for separating crosscutting concerns, something usually hard to do in object-oriented programming. The application’s modularity is increased in that way and its maintenance becomes significantly easier.

- **Container:**

  Spring contains and manages the life cycle and configuration of application objects.

- **MVC Framework:**

  Spring comes with MVC web application framework, built on core Spring functionality. This framework is highly configurable via strategy interfaces, and accommodates multiple view technologies like JSP, Velocity, Tiles, iText, and POI.

- **Transaction Management:**

  Spring framework provides a generic abstraction layer for transaction management. This allowing the developer to add the pluggable transaction managers, and making it easy to demarcate transactions without dealing with low-level issues.

- **JDBC Exception Handling:**

  The JDBC abstraction layer of the Spring offers a meaningful exception hierarchy, which simplifies the error handling strategy. Integration with Hibernate, JDO, and iBATIS: Spring provides best Integration services with Hibernate, JDO and iBATIS

#### What is Dependency Injection ? ####

The basic concept of the dependency injection (also known as Inversion of Control pattern) is that you do not create your objects but describe how they should be created. You don’t directly connect your components and services together in code but describe which services are needed by which components in a configuration file. A container (in the case of the Spring framework, the IOC container) is then responsible for hooking it all up.
i.e., Applying IoC, objects are given their dependencies at creation time by some external entity that coordinates each object in the system. That is, dependencies are injected into objects. So, IoC means an inversion of responsibility with regard to how an object obtains references to collaborating objects.



There are three main ways to inject dependency:

- via setter method
- via constructor method
- autowiring



#### Scopes ####

- **singleton(Default)** – Scopes a single bean definition to a single object instance per Spring IoC container.
- **prototype** – Return a new bean instance each time when requested
- **request** – Return a single bean instance per HTTP request.
- **session** – Return a single bean instance per HTTP session.
- **globalSession** – Return a single bean instance per global HTTP session.



## Injection Dependency

Dependency between classes is basically assigning references to attributes. Since a class has a attribute refers to another class, dependency exists. i.e.

```java
class UserService{
    UserDao userDao = new UserDao();
}
```

#### dependency handling provided by Spring

- Constructor:

```xml
<constructor-arg index="0" name="userDao" type="UserDao" ref="userDao"></constructor-arg>
```



- Set method

```xml
<property name="userDao" ref="userDao"/>
```

optimizer:  **p:userDao-ref**

There is no need to use property node:

```xml
 <bean id="userService" class="UserService" p:userDao-ref="userDao"/>
```



- autowiring (read  `AutoWiring` section below)



#### Why field injection should be avoided?

- ou cannot create immutable objects, as you can with constructor injection
- Your classes have tight coupling with your DI container and cannot be used outside of it
- Your classes cannot be instantiated (for example in unit tests) without reflection. You need the DI container to instantiate them, which makes your tests more like integration tests
- Your real dependencies are hidden from the outside and are not reflected in your interface (either constructors or methods)
- It is really easy to have like ten dependencies. If you were using constructor injection, you would have a constructor with ten arguments, which would signal that something is fishy. But you can add injected fields using field injection indefinitely. Having too many dependencies is a red flag that the class usually does more than one thing, and that it may violate the Single Responsibility Principle.

[READ MORE](https://stackoverflow.com/questions/39890849/what-exactly-is-field-injection-and-how-to-avoid-it)

## Application Context ##

ApplicationContext is an central interface for providing configuration information to an application.

#### Features ####

- Bean factory methods, inherited from `ListableBeanFactory`. This avoids the need for applications to use singletons.
- The ability to resolve messages, supporting internationalization. Inherited from the `MessageSource` interface.
- The ability to load file resources in a generic fashion. Inherited from the `ResourceLoader` interface.
- The ability to publish events. Implementations must provide a means of registering event listeners.
- Inheritance from a parent context. Definitions in a descendant context will always take priority. This means, for example, that a single parent context can be used by an entire web application, while each servlet has its own child context that is independent of that of any other servlet.



## LifeCycle ##

```xml
<bean id="lifecycle" class="uk.ac.ucl.lifecycle.Lifecycle"
      init-method="init" destroy-method="destroy"/>
```



### Default Initialization and destroy method ###

If you have too many beans having initialization and or destroy methods with the same name, you don’t need to declare **init-method** and **destroy-method** on each individual bean. Instead framework provides the flexibility to configure such situation using **default-init-method** and **default-destroy-method** attributes on the element as follows:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aop="http://www.springframework.org/schema/aop"
 xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.0.xsd"
 default-init-method="init"
 default-destroy-method="destroy"
 >
 
 <bean id="country" class="org.arpit.javapostsforlearning.Country">
 <property name="countryName" value="India"/>
 </bean>
 
</beans>
```



## Anotation based Configuration ##

#### what if both have been done i.e.used annotations and XML? ####

In that case, XML configuration will override annotations because XML configuration will be injected after annotations.

#### Important Anotations List ####

- **@Required**

 The @Required annotation applies to bean property setter methods.

- **@Autowired**

The @Autowired annotation can apply to bean property setter methods, non-setter methods, constructor and properties.

- **@Qualifier**

The @Qualifier annotation along with @Autowired can be used to remove the confusion by specifiying which exact bean will be wired.

- **JSR 250 Annotations**

Spring supports JSR-250 based annotations which include @Resource, @PostConstruct and @PreDestroy annotations.



## AutoWiring ##

```xml
<bean id="country" class="org.arpit.javapostsforlearning.Country" autowire="byName">
```

In Spring framework, you can wire beans automatically with auto-wiring feature. To enable it, just define the “**autowire**” attribute in .The Spring container can **autowire** relationships between collaborating beans without using and elements which helps cut down on the amount of XML configuration

#### modes ####

- **no:**

Default, no auto wiring, set it manually via “ref” attribute as we have done in dependency injection via settor method post.

- **byName:**

Autowiring by property name. Spring container looks at the properties of the beans on which *autowire* attribute is set to *byName* in the XML configuration file and it tries to match it with name of bean in xml configuration file.

- **byType:**

Autowiring by property datatype. Spring container looks at the properties of the beans on which *autowire* attribute is set to *byType* in the XML configuration file. It then tries to match and wire a property if its **type** matches with exactly one of the beans name in configuration file. **If more than one such beans exists, a fatal exception is thrown.**

- **contructor:**

byType mode in constructor argument.

- **autodetect:**

Spring first tries to wire using autowire by *constructor*, if it does not work, Spring tries to autowire by *byType*.

#### Limitations ####

- **OverRiding possibilities:**You can still define dependencies using or tag which will always override autowiring.
- **Primitive data type**:you have to define primitive data type like String or Interger using or tag.You can not autowire them.
- **Confusing Nature**:If you have lot of dependency in program,then its very hard to find out using autowire attribute of bean.



# Spring AOP #

### Why AOP ###

It provides pluggable way to apply concern before, after or around business logic.

Lets understand with the help of logging. You have put logging in different classes but for some reasons, if you want to remove logging now, you have to make changes in all classes but you can easily solve this by using aspect. If you want to remove logging, you just need to unplug that aspect.



### Terminologies

#### Aspect

An Aspect is a class that implements concerns that cut across different classes such as logging. It is just a name.

For example, a logging module would be called AOP aspect for logging. An application can have any number of aspects depending on the requirement.

#### Joint point

This represents a point in your application where you can plug-in the AOP aspect. You can also say, it is the actual place in the application where an action will be taken using Spring AOP framework.

#### Advice

This is the actual action to be taken either before or after the method execution. This is an actual piece of code that is invoked during the program execution by Spring AOP framework.

#### Pointcut

This is a set of one or more join points where an advice should be executed. Spring uses the **AspectJ pointcut expression**(more at below) language by default.

#### Target Object

The object being advised by one or more aspects. This object will always be a proxied object, also referred to as the advised object.  For example: There are the object on which you want to apply logging on joint point.



## Configured by annotation

**@Aspect :** To declare a class as Aspect.
Annotations which are used to create Advices are:
**@Before :** @Before annotation is used to create **before advice**. It executes before actual method execution (Join points)
**@AfterReturning:** This annotation is used to create **return advice**. It executes after a method execution completes without any exception.
**@AfterThrowing:** This annotation is used to create **After throwing advice,** it executes if method exits by throwing an exception.
**@After :** This annotation is used to create **after advice,** it executes after a method execution  regardless of outcome.
**@Around :** This annotation is used to create **around advice,** It executes before and after a join point.

## Configured by xml

### Pointcut

```xml
<aop:pointcut id="pointCut" expression="PointCut expression here"/>
```

### Advice

```xml
<aop:before method="the advice to be executed" pointcut-ref="pointCut"/>
```



## Proxy Mechanism

Spring AOP uses either JDK dynamic proxies or CGLIB to create the proxy for a given target object. (JDK dynamic proxies are preferred whenever you have a choice) from [Official Document](https://docs.spring.io/spring/docs/3.0.0.M3/reference/html/ch08s06.html)

**If the target object to be proxied implements at least one interface then a JDK dynamic proxy will be used. **All of the interfaces implemented by the target type will be proxied. **If the target object does not implement any interfaces then a CGLIB proxy will be created.**



### Dynamic proxy

Static proxy has to implement every method in the interface of the target class. Meanwhile, static proxy is generated during compiling time. Dynamic proxies differ from static proxies in a way that **they do not exist at compile time. Instead, they are generated at runtime by the JDK and then made available to the users at runtime.**

Java provides a class `Proxy`, its method `newInstance()` can generate a proxy class for a target class. Three parameters are required by this method:

1. classLoader (generally the class loader of the target class is used)
2. the interface of the target class (**The target class must implement an interface**)
3. What should be expected from proxy class? (**Implement the InvocationHandler interface**)



#### Invocation handler

An invocation handler intercepts call to the implementation, performs some programming logic, and then passes on the request to the implementation. All of the operations will be invoked through the `invoke()` method in Invocation handler. i.e. [from Java3y](https://mp.weixin.qq.com/s?__biz=MzI4Njg5MDA5NA==&mid=2247484222&idx=1&sn=5191aca33f7b331adaef11c5e07df468&chksm=ebd7423fdca0cb29cdc59b4c79afcda9a44b9206806d2212a1b807c9f5879674934c37c250a1&scene=21#wechat_redirect)

```java
Programmer programmerWaterArmy = (Programmer) Proxy.newProxyInstance(java3y.getClass().getClassLoader(), java3y.getClass().getInterfaces(), (proxy, method, args) -> {
						// reflection can be used here
            if (method.getName().equals("coding")) {
                method.invoke(java3y, args);
                System.out.println("Coding here");

            } else {
                return method.invoke(java3y, args);
            }

            return null;
        });
```



### CGLIB proxy

When target class does not implement any interface, CGLIB proxy will be used. Check `uk/ac/ucl/aop/springAOP/cglibProxy/OrderMain.java` for example.



#### Why CGLIB proxy is needed?

static proxy has to implement the same interfaces that target object possesses, so dynamic proxy is needed.

dynamic proxy requires that target object must possess interface, CGLIB proxy solves this restriction.



## Pointcut expression([source](https://www.baeldung.com/spring-aop-pointcut-tutorial))

A pointcut expression can appear as a value of the `@Pointcut` or `@Before` or `@After` annotation:

It provides a name that can be used by advice annotations to refer to that pointcut.

for example:

```java
@After("execution(* uk.ac.ucl.aop.springAOP.dynamicProxy.*.*(..))")
```

means apply this `advice` to all the classes with all their methods under the`.../dynamicProxy`, 

__dynamicProxy.*__ is a wild card that matches all the classes and the next * matches all the methods

the **(..)** pattern matches any number of parameters (zero or more).

also:

```java
@After("execution(* uk.ac.ucl.aop.springAOP.dynamicProxy.Example.save(Long)")
```

means matching exactly the `save` method in `Example` class.



### Pointcut Designator(PCD)

A pointcut expression starts with a PCD, which is a keyword telling Spring AOP what to match. There are several pointcut designators, such as the execution of a method, a type, method arguments, or annotations.

#### **execution**

The primary Spring PCD is *execution*, which matches method execution join points.

#### **within**

imits matching to join points of certain types, for example:

```java
@Pointcut("within(com.baeldung..*)")
```

means matching any type within the *com.baeldung* package or a sub-package.

#### **this and target**

**this** limits matching to join points where the bean reference is an instance of the given type, while **target** limits matching to join points where the target object is an instance of the given type. **The former works when Spring AOP creates a CGLIB-based proxy, and the latter is used when a JDK-based proxy is created.** 


[**Official ducument for Pointcut expression**](https://docs.spring.io/spring/docs/2.0.x/reference/aop.html)

