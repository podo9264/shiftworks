package org.shiftworks.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.shiftworks.domain.BookingPageDTO;
import org.shiftworks.domain.BookingVO;
import org.shiftworks.domain.BookingCriteria;
import org.shiftworks.service.BookingService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;


@RestController
@Log4j
@RequestMapping("/booking/*")
@AllArgsConstructor
public class BookingController {
	
	private BookingService service;
	
	//getList 테스트 메서드(list만 가져오고 view없음) -> 리스트 출력은 ok, 달력에 출력은 x
	@GetMapping("/calendar")
	@PreAuthorize("isAuthenticated()")
	public List<Map<String, Object>> getCalbookings() {
		List<BookingVO> bookingList = service.getList();
		
		List<Map<String, Object>> calList = new ArrayList<Map<String,Object>>();

		for(int i=0;i<bookingList.size();i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			//map.put("start", bookingList.get(i).getBook_date());

			String begin = bookingList.get(i).getBook_begin();
			int getEndTime = Integer.parseInt(bookingList.get(i).getBook_begin())+2;
			String end = Integer.toString(getEndTime);
			
			map.put("title", bookingList.get(i).getBook_title());
			map.put("start", bookingList.get(i).getBook_date().substring(0, 10)+"T"+begin+":00");
			map.put("end", bookingList.get(i).getBook_date().substring(0, 10)+"T"+end+":00");
			/* map.put("color", "red"); */
			/* map.put("backgroundColor", "#1C3359"); */
			calList.add(i, map);
			//calList.add(map);
		}
		//calList.add(map);

		return calList;
	}
	
	//calendar test method -> calendar view 출력용(list 못가져옴)
	@GetMapping("/calendar/view")
	@PreAuthorize("isAuthenticated()")
	public ModelAndView getCalList() {
		ModelAndView mav = new ModelAndView();
		List<BookingVO> list = service.getList();
		log.info("list확인......................................>"+list);
		
		String json = new Gson().toJson(list);
		log.info("json변환 확인....................................."+json);

		mav.setViewName("booking/BOK_mainCal");
		mav.addObject("event", json);
		
		log.info("cal controller..........................mav.......................");
		log.info(mav);
		log.info("json결과: ---------------------------------------"+json);

		return mav;
	}
	
	//예약폼 페이지로 이동
	@GetMapping("/new")
	@PreAuthorize("isAuthenticated()")
	public ModelAndView insertBooking() throws Exception{
		ModelAndView mav = new ModelAndView();
		mav.setViewName("booking/BOK_insertForm");
		return mav;
	}
	
	//예약하기
	@PostMapping(value ="/new", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
	@PreAuthorize("isAuthenticated()")
	public ResponseEntity<String> insertBooking(@RequestBody BookingVO vo) {
		
		log.info("insertBooking controller.............");
		//service.insertBooking(vo);
		int re = service.insertBookingCondition(vo);
		log.info(vo);
		log.info(re);
		
		return re == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>("fail", HttpStatus.OK);
		//return new ResponseEntity<String>("success Reservation", HttpStatus.OK);
	}
	
	//예약 1개 상세보기
	@GetMapping("/{book_id}")
	@PreAuthorize("isAuthenticated()")
	public ModelAndView getBooking(@PathVariable("book_id") int book_id) {
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("booking/BOK_detail");
		mav.addObject("event", service.getBooking(book_id));
		
		return mav;
	}
	
	
	//전체 예약 현황보기(+페이징)(게시판 이동)
	@GetMapping("/list")
	@PreAuthorize("isAuthenticated()")
	public ModelAndView getList(BookingCriteria cri, ModelAndView mav) {
		//List<BookingVO> list = service.getList();
		//ModelAndView mav = new ModelAndView();
		log.info("list: "+cri);
		mav.setViewName("booking/BOK_list");
		mav.addObject("event", service.getListwithPaging(cri));
		//mav.addObject("pageMaker", new BookingPageDTO(cri, 123));
		
		int total = service.getTotalCount(cri);
		log.info("total: "+total);
		mav.addObject("pageMaker", new BookingPageDTO(cri, total));
		
		return mav;
	}
	
	
	//내 예약 현황보기(게시판 형식)
	@GetMapping("/mylist")
	@PreAuthorize("isAuthenticated()")
	public ModelAndView getMyList(Authentication auth){
		log.info("getMyList controller....................");
		
		UserDetails ud = (UserDetails)auth.getPrincipal();
		log.info(ud.getUsername());
		String emp_id = ud.getUsername();
		
		List<BookingVO> myList = service.getMyList(emp_id);
		ModelAndView mav = new ModelAndView();

		mav.setViewName("booking/BOK_myList");
		mav.addObject("event", myList);
		log.info(myList);
		
		return mav;
	}
	
	//예약 취소하기
	@PostMapping("/{book_id}")
	@PreAuthorize("isAuthenticated()")
	public ResponseEntity<String> deleteBooking(@PathVariable("book_id") int book_id) {
		log.info("deleteBooking controller..................");
		int re = service.deleteBooking(6);
		log.info(re);
		
		return new ResponseEntity<String>("success", HttpStatus.OK);
	}
	




}
