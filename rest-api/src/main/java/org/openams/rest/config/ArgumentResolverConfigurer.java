package org.openams.rest.config;

import java.util.List;

import org.openams.rest.controller.resolver.PagableArgumentResolver;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebMvc
public class ArgumentResolverConfigurer implements WebMvcConfigurer {

	@Override
	public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
		argumentResolvers.add(pagableArgumentResolver());
	}
	
	@Bean
	public PagableArgumentResolver pagableArgumentResolver(){
		return new PagableArgumentResolver();
	}
	
}
