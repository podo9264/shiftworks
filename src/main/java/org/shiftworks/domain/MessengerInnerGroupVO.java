package org.shiftworks.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MessengerInnerGroupVO {
	private int igroup_id;
	private int group_id;
	private String iname;
}
