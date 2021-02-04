package com.main.test;
import org.testng.Assert;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;
import java.net.MalformedURLException;
import com.google.common.util.concurrent.Uninterruptibles;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.BeforeTest;
import org.openqa.selenium.By;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.concurrent.TimeUnit;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.testng.annotations.AfterTest;
import org.openqa.selenium.PageLoadStrategy;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.CapabilityType;
public class UUIDTest {
protected WebDriver driver;
    
    @BeforeSuite
    public void initialDelay(){
        //intentionally added this as chrome containers take few ms to register
        //to hub - test fails saying hub does not have node!!
        Uninterruptibles.sleepUninterruptibly(2, TimeUnit.SECONDS);
        
    }
    @BeforeTest
    public void setUp() throws MalformedURLException {
        System.out.println("before test");  
	DesiredCapabilities capabilities = DesiredCapabilities.chrome();
	ChromeOptions options = new ChromeOptions();
	options.addArguments("headless");
	capabilities.setCapability(ChromeOptions.CAPABILITY, options);
	driver = new RemoteWebDriver(new URL("http://localhost:4444/wd/hub"), capabilities);
        driver.manage().window().maximize();
    }

   @Test()
    public void googleTest() {
              
        driver.get("http://devopsteamgoa.westindia.cloudapp.azure.com:9090/MusicStore/version.html");
        // get the current URL of the page   
        String URL= driver.getCurrentUrl();  
        System.out.println("current URL of the page fetched: "+URL); 
        //get the title of the page  
        String s1 = System.getProperty("uuid");
        String bodyText;
        bodyText = driver.findElement(By.tagName("body")).getText();
        System.out.println(bodyText);  
        if(bodyText.equals(s1))
        {
            Assert.assertTrue(true);
        }
        else
        {
            Assert.assertTrue(false);
        }
    }
	
    @AfterTest
    public void tearDown() throws InterruptedException {
        driver.close();
        driver.quit();
    }  

}
