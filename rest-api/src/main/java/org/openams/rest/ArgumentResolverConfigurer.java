package org.openams.rest;

import java.util.List;

import org.openams.rest.controller.resolver.PagableArgumentResolver;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Configuration
@EnableWebMvc
public class ArgumentResolverConfigurer extends WebMvcConfigurerAdapter {

	@Override
	public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
		super.addArgumentResolvers(argumentResolvers);
		argumentResolvers.add(pagableArgumentResolver());
	}
	
	@Bean
	public PagableArgumentResolver pagableArgumentResolver(){
		return new PagableArgumentResolver();
	}
	
}
