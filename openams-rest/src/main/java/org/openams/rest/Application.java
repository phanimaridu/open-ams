package org.openams.rest;

import org.jsondoc.spring.boot.starter.EnableJSONDoc;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.orm.jpa.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJSONDoc
@EntityScan(basePackages = {"org.openams.rest.jpa.entity"})
@EnableJpaRepositories(basePackages = {"org.openams.rest.jpa.repository"})
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}
}