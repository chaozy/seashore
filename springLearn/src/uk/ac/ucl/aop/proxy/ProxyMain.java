package uk.ac.ucl.aop.proxy;

public class ProxyMain {
    public static void main(String[] args) {
        UserDao userDao = new UserDao();
        UserDao factory = (UserDao) new ProxyFactory(userDao).getProxyInstance();
        factory.upload();
    }
}
