package org.openams.rest;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = TestConfig.class, webEnvironment=WebEnvironment.RANDOM_PORT)
public class ApplicationTests {

	@Test
	public void contextLoads() {
		System.out.println("Worked");
	}

}
