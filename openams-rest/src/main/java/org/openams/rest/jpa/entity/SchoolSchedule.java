package org.openams.rest.jpa.entity;

import java.io.Serializable;
import javax.persistence.*;
import java.util.Date;


/**
 * The persistent class for the school_schedule database table.
 * 
 */
@Entity
@Table(name="school_schedule")
@NamedQuery(name="SchoolSchedule.findAll", query="SELECT s FROM SchoolSchedule s")
public class SchoolSchedule implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private int id;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="end_dtt")
	private Date endDtt;

	@Column(name="event_name")
	private String eventName;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="start_dtt")
	private Date startDtt;
	
	//TODO:List reasonable values and Create ENUM
	private byte status;

	//bi-directional many-to-one association to Staff
	@ManyToOne
	@JoinColumn(name="annonced_by")
	private Staff staff;

	public SchoolSchedule() {
	}

	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Date getEndDtt() {
		return this.endDtt;
	}

	public void setEndDtt(Date endDtt) {
		this.endDtt = endDtt;
	}

	public String getEventName() {
		return this.eventName;
	}

	public void setEventName(String eventName) {
		this.eventName = eventName;
	}

	public Date getStartDtt() {
		return this.startDtt;
	}

	public void setStartDtt(Date startDtt) {
		this.startDtt = startDtt;
	}

	public byte getStatus() {
		return this.status;
	}

	public void setStatus(byte status) {
		this.status = status;
	}

	public Staff getStaff() {
		return this.staff;
	}

	public void setStaff(Staff staff) {
		this.staff = staff;
	}

}