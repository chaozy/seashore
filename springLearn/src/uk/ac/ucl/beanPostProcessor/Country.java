package uk.ac.ucl.beanPostProcessor;

public class Country {
    private String countryName;

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    private void init() {
        System.out.println("Init phase");
    }

    private void destroy() {
        System.out.println("Destroy phase");
    }
}
