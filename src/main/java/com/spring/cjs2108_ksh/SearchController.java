package com.spring.cjs2108_ksh;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeDriverService;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping(value="/search")
public class SearchController {
	
	@RequestMapping("/searchKeyword")
	public String searchKeyword(Model model,
			@RequestParam(name="keyword", defaultValue="", required=false) String keyword) {
			System.out.println(keyword);
			String keywordTrim = keyword.replaceAll(" ", "");//검색어 공백 제거
			System.out.println(keywordTrim);
			
			
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
				driver.get("https://m.kinolights.com/");
				Thread.sleep(900);
				driver.findElement(By.xpath("//*[@id=\"search\"]")).click();
				Thread.sleep(900);
				driver.findElement(By.xpath("//*[@id=\"search\"]")).sendKeys(keyword);
				Thread.sleep(900);
				wait.until(ExpectedConditions.presenceOfElementLocated(By.className("movie-item")));
				Thread.sleep(900);
				
				WebElement searchTitle = driver.findElement(By.className("name"));
				String searchTitleTrim = (searchTitle.getText()).replaceAll(" ", "");
				
				System.out.println("searchTitle.getText : " + searchTitle.getText());
				System.out.println("searchTitleTrim : " + searchTitleTrim);
				
				if(searchTitleTrim != "" && searchTitleTrim.contains(keywordTrim)) {
					driver.findElement(By.className("name")).click();
					Thread.sleep(800);
					
					wait.until(ExpectedConditions.presenceOfElementLocated(By.className("title-kr")));
					
					String contentTitle = driver.findElement(By.xpath("//*[@id=\"contents\"]/div[2]/div[5]/div[1]/h3")).getText();
					System.out.println(contentTitle);
					model.addAttribute("contentTitle",contentTitle);
					
					//검색 결과 ott 있는지
					String[] ottList = new String[10];
					String[] ottLinkList = new String[10];
					List<WebElement> ott = driver.findElements(By.className("movie-price-link-wrap"));
					List<WebElement> ottLink = driver.findElements(By.className("movie-price-link"));
					for(int i = 0; i<ott.size(); i++) {
						ottList[i] = ott.get(i).getText();
						System.out.println(""+i+"" + ott.get(i).getText());
						
					}
					
					for(int j=0; j<ottLink.size(); j++) {
						//String link = ott.get(j).getAttribute("href");
						//System.out.println(ottLink.get(j).getAttribute("href"));
						ottLinkList[j] = ottLink.get(j).getAttribute("href");
					}
					model.addAttribute("ott", ottList);
					model.addAttribute("ottLink", ottLinkList);
					model.addAttribute("keyword", keyword);
				}
				else {
					System.out.println("검색 결과 없음");
					String none = "";
					model.addAttribute("none",none);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				driver.quit();
				service.stop();
			}
		return "main/searchResult";
	}
	
}
