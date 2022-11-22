package org.shiftworks.service;

import java.util.List;

import org.shiftworks.domain.EmployeeVO;
import org.shiftworks.mapper.MessengerMapper;
import org.springframework.beans.factory.annotation.Autowired;

public class MessengerServiceImpl implements MessengerService {
	
	@Autowired
	private MessengerMapper messengerMapper;

	@Override
	public List<EmployeeVO> getList() {
		
		return messengerMapper.getList();
	}
}
