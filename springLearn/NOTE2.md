# Spring DAO

## c3p0



## Namespace

Spring provides several namespaces to **simplify XML configuration**, such as jdbc, tx, aop, etc. 

An [XML namespace](http://en.wikipedia.org/wiki/XML_namespace) is just a token that, for lack of a better description, identifies whose "version" a particular tag or attribute is. The idea is to prevent conflicts if, for instance, you're using XML with elements defined by multiple people/programs/standards bodies/etc. For instance, a program that I write that uses xml might use the namespace `http://www.ttdi.us/xml/myapp`.[source](https://stackoverflow.com/questions/4790916/what-is-an-xml-namespace-and-what-does-it-have-to-do-with-spring-transactions)

## Transcation Management

*Most users of the Spring Framework choose **declarative transaction management**. It is the option with the least impact on application code, and hence is most consistent with the ideals of a \*non-invasive\* lightweight container.*

- Unlike EJB CMT, which is tied to JTA, the Spring Framework's declarative transaction management works in any environment. It can work with JDBC, JDO, Hibernate or other transactions under the covers, with configuration changes only.

- The Spring Framework offers declarative [*rollback rules*:](https://docs.spring.io/spring/docs/3.0.0.M3/reference/html/ch11s05.html#transaction-declarative-rolling-back) this is a feature with no EJB equivalent. Both programmatic and declarative support for rollback rules is provided.

[READ this offical doc for more information] (https://docs.spring.io/spring/docs/3.0.0.M3/reference/html/ch11s05.html)

### Programmatic vs. Declarative

Spring supports two types of transaction management −

- [Programmatic transaction management](https://www.tutorialspoint.com/spring/programmatic_management.htm) − This means that you have to manage the transaction with the help of programming. That gives you extreme flexibility, but it is difficult to maintain.
- [Declarative transaction management](https://www.tutorialspoint.com/spring/declarative_management.htm) − This means you separate transaction management from the business code. You only use annotations or XML-based configuration to manage the transactions. It is based on AOP. It will insert a transaction in the beginning of the target method, and decides whether to commit it or roll back according to the running.

**Why declarative is better than programmatic?**

NO transaction management code is put into the bussiness logic code, only the configuration files have to be modified or annotations are added. This follows the principle of Spring: non-invasive framework.



### Roll Back

The recommended way to indicate to the Spring Framework's transaction infrastructure that a transaction's work is to be rolled back is **to throw an `Exception` from code that is currently executing in the context of a transaction.** **The Spring Framework's transaction infrastructure code will catch any unhandled `Exception` as it bubbles up the call stack, and will mark the transaction for rollback.**



**Be careful, only runtime exception (no requirement for catch or throw), by default, will cause roll back of a transaction. Spring will think the programmer will handle the Checked Exception by themselves. ** If checked exception also requires roll back, configuration needs to be added as below:

```java
@Transactional(rollbackFor = { Exception.class })
```



**Example code**: Exactly which `Exception` types mark a transaction for rollback can be configured. Find below a snippet of XML configuration that demonstrates how one would configure rollback for a checked, application-specific `Exception` type.

```xml
<tx:advice id="txAdvice" transaction-manager="txManager">
  <tx:attributes>
  <tx:method name="get*" read-only="true" rollback-for="NoProductInStockException"/>
  <tx:method name="*"/>
  </tx:attributes>
</tx:advice>
```



It's much simpler if annotation is used to implement transaction management. Just using `@Transactional` to wrap the method or class. Remember to turn on this feature in beans.xml.

```xml
<tx:annotation-driven transaction-manager="txManage"/>
```

NOTE: **However, if we put the annotation on a private or protected method, Spring will ignore it without an error.**



### Transaction Propagation

Below are the 2 most commonly used propagation types. The other 5 will not explained here: SUPPORTS, MANDATORY, NEVER, NOT_SUPPORTED, NESTED

### REQUIRED

*REQUIRED* is the default propagation(So we can simplified the code by dropping it). Spring checks if there is an active transaction, then it creates a new one if nothing existed. Otherwise, the business logic appends to the currently active transaction

#### REQUIRES_NEW

When the propagation is *REQUIRES_NEW*, Spring suspends the current transaction if it exists and then creates a new one.

[READ THIS](https://juejin.im/post/6844903608224333838)



# Spring Anotation

**With Spring’s auto-scanning feature, it automatically detects various beans defined in our application.** We usually annotate our beans using one of the available Spring annotations – *@Component, @Repository, @Service, @Controller*.

## @Component

We can use *@Component* annotation to mark a bean as a Spring-managed component. In other words, **it’s a generic for any Spring-managed component**.

We can enable an auto-scan using *<context:component-scan>* tag. During auto-scan, Spring will scan and register all beans marked with a *@Component* annotation.



## @Repository

Since *@Repository* is a type of *@Component*, Spring also auto-scans and registers them.

***@Repository\* is a stereotype for the persistence layer. Its job is to catch all persistence related exceptions and rethrow them as a Spring \*DataAccessException\*.**

For this, we should configure *PersistenceExceptionTranslationPostProcessor* in our application context:

```xml
<bean class=
  "org.springframework.dao.annotation.PersistenceExceptionTranslationPostProcessor"/>
```

**This bean post processor adds an advisor to all beans marked with *@Repository*. The advisor’s responsibility is to translate the platform-specific exceptions to the Spring’s unified unchecked exceptions.**



## @Service

Just like *@Repository, @Service* is another specialization of **@Component**

The ***@Service\* annotation represents that our bean holds some business logic.** Till date, it doesn’t provide any specific behavior over *@Component*.

Still, **we should annotate the service-layer beans with the \*@Service\* annotation to make our intent clear.** Additionally, we never know if someday Spring chooses to add some specific functionality to it.



## Basic Differences

- *@Component* is the most generic stereotype and marks a bean as a Spring-managed component
- Both *@Service* and *@Repository* annotations are the specializations over the *@Component* annotation
- *@Repository* is a stereotype used for persistence layer. It translates any persistence related exceptions into a Spring’s *DataAccessException*
- *@Service* is used for the beans at the service layer. Currently, it doesn’t offer any additional functionality over *@Component*
- **It’s always preferable to use *@Repository* and *@Service* annotations over *@Component*, wherever applicable. It communicates the bean’s intent more clearly**

