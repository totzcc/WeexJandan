package com.totzcc;

import java.io.IOException;
import java.net.MalformedURLException;

import javax.servlet.http.HttpServletResponse;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.embedded.ConfigurableEmbeddedServletContainer;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class SimpleApplication implements EmbeddedServletContainerCustomizer {
	public static void main(String[] args) {
		SpringApplication.run(SimpleApplication.class, args);
	}

	@GetMapping("/")
	public void conver(String url, HttpServletResponse response) throws MalformedURLException, IOException {
		response.setContentType("text/html;charset=utf8");
		if (url == null || url.isEmpty()) {
			url = "http://jandan.net/2017/04/22/predict-bickering.html";
		}
		response.getWriter().write(conver(url));
	}
	
	public static String conver(String url) throws MalformedURLException, IOException {
		StringBuffer html = new StringBuffer();
		html.append("<!DOCTYPE html>\n");
		html.append("<html>\n");
		html.append("<head>\n");
		html.append("<meta charset=\"UTF-8\">\n");
		html.append(
				"<link rel=\"stylesheet\" href=\"http://wl-store-0001.oss-cn-beijing.aliyuncs.com/html/weex/jandan/resources/read.css\" />\n");
		html.append("<script src=\"https://lib.sinaapp.com/js/jquery/2.0.3/jquery-2.0.3.min.js\"></script>\n");
		html.append("<script src=\"//cdn.jandan.net/static/js/jquery.lazyload.min.js?v=201603020\"></script>\n");
		html.append("</head>\n");
		html.append("<body>\n");

		Document document = Jsoup.connect(url).get();
		Elements selects = document.select("#content .post");
		html.append(selects.get(0).html());
		html.append("\n");
		html.append(
				"<script src=\"http://wl-store-0001.oss-cn-beijing.aliyuncs.com/html/weex/jandan/resources/read.js\"></script>\n");
		html.append("</body>\n");
		html.append("</html>\n");
		return html.toString();
	}

	@Override
	public void customize(ConfigurableEmbeddedServletContainer container) {
		container.setPort(8090);
	}
}
