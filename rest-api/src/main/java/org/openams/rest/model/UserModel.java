package org.openams.rest.model;

import java.util.Collection;
import java.util.Date;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.NotEmpty;
import org.openams.rest.jpa.entity.enums.UserStatus;

import com.fasterxml.jackson.annotation.JsonFormat;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel(description = "User Account Data")
public class UserModel {

	@ApiModelProperty(value = "User Name", required = true, dataType = "String")
	@NotNull
	@NotEmpty
	@Size(min = 1, max=255)
	private String userName;

	@ApiModelProperty(value = "E Mail; Password will be sent to this e-mail", dataType = "String")
	@NotNull
	@NotEmpty
	@Size(min = 1, max=255)
	private String email;

	@ApiModelProperty(value = "User Account Status", required = true, dataType = "UserStatus")
	private UserStatus status;

	@ApiModelProperty(value = "Account Expire Date Time in GMT Epoch Milli Seconds; Type : long", dataType = "long")
	@JsonFormat(pattern="yyyy-MM-dd-HH-mm-ss")
	private Date accountExpireDtt;
	
	@ApiModelProperty(value = "Credentials Expire Date Time in GMT Epoch Milli Seconds; Type : long", dataType = "long")
	@JsonFormat(pattern="yyyy-MM-dd-HH-mm-ss")
	private Date credentialsExpireDtt;
	
	@ApiModelProperty(value = "Last Access Date Time in GMT Epoch Milli Seconds; Type : long", dataType = "long")
	@JsonFormat(pattern="yyyy-MM-dd-HH-mm-ss")
	private Date lastAccessDtt;
	
    @ApiModelProperty(value = "User Roles", required = true, dataType = "Collection")
    @NotNull
    @NotEmpty
	private Collection<String> roles;

}
