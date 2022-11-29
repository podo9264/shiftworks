package org.shiftworks.controller;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.shiftworks.domain.ApprovalCriteria;
import org.shiftworks.domain.BookingVO;
import org.shiftworks.service.ApprovalService;
import org.shiftworks.service.BookingService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import lombok.AllArgsConstructor;

/**
 * Handles requests for the application home page.
 */
@Controller
@AllArgsConstructor
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	private BookingService bookingService;
	private ApprovalService appService;

	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String homeContent(Model model) {
		List<BookingVO> eventList = new ArrayList<BookingVO>();
		List<BookingVO> list = bookingService.getList();

		
		if(list == null) {
			return "예약이 없습니다";
		}else {
			for(int i=0;i<list.size();i++) {
				eventList.add(list.get(i));
			}
		}
		
		
		//예약 리스트(게시판 형태)
		//model.addAttribute("event", bookingService.getList());
		model.addAttribute("event", eventList);
		
		//model.addAttribute("get", bookingService.getBooking(205));
		//model.addAttribute("event2", sservice.getList());
		
		//model.addAttribute("board", service.boardList());
		//게시판 글목록 가져오기
		//model.addAttribute("board", service.boardList());
		
		
		return "home"; 
	}
	
	
	
	
}
