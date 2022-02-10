package com.spring.cjs2108_ksh;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeDriverService;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
public class App {
	public static void main(String[] args) {
		
		final File driverFile = new File("chromedriver.exe");
		final String driverFilePath = driverFile.getAbsolutePath();
		if(!driverFile.exists() && driverFile.isFile()) {
			throw new RuntimeException("Not fount file. or this is not file.<" + driverFilePath + ">");
			
		}
		
		final ChromeDriverService service;
		service = new ChromeDriverService.Builder()
				.usingDriverExecutable(driverFile)
				.usingAnyFreePort()
				.build();
		try {
			service.start();
		} catch (Exception e) {
			e.printStackTrace();
		}
		final WebDriver driver = new ChromeDriver(service);
		final WebDriverWait wait = new WebDriverWait(driver, 10);
		
		try {
			driver.get("https://www.justwatch.com/kr");
			Thread.sleep(800);
			driver.findElement(By.xpath("//*[@id=\"app\"]/div[3]/div/div[2]/div[1]/div/ion-searchbar/div/input")).click();
			driver.findElement(By.xpath("//*[@id=\"app\"]/div[3]/div/div[2]/div[1]/div[1]/ion-searchbar/div/input")).sendKeys("이터널 선샤인"+Keys.ENTER);
			Thread.sleep(800);
			driver.findElement(By.className("searchsuggester__footer")).click();
			
			wait.until(ExpectedConditions.presenceOfElementLocated(By.className("title-list-row__row-header-title")));
			
			//검색 결과 작품 제목들
			List<WebElement> title = driver.findElements(By.className("title-list-row__row-header-title"));
			
			//검색 결과 작품 스트리밍
			WebElement searchResult = driver.findElement(By.xpath("//*[@id=\"base\"]/div[3]/div/div[2]/ion-grid/div/ion-row[1]/ion-col[2]"));
			List<WebElement> streaming = searchResult.findElements(By.xpath("//*[@id=\"base\"]/div[3]/div/div[2]/ion-grid/div/ion-row[1]/ion-col[2]/div[1]/div[2]/div/div[1]"));
			
			for(int i = 0; i<streaming.size(); i++) {
				System.out.println("스트리밍 여부 : " + streaming.get(i).getText());
			}
			
			System.out.println("조회된 작품 제목 수 : " + title.size());
			int cnt = 1;
			for(int i = 0; i<title.size(); i++) {
				System.out.println(""+cnt+"번 작품 : " + title.get(i).getText());
				cnt++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			driver.quit();
			service.stop();
		}
	}
}
