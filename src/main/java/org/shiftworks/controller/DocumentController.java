package org.shiftworks.controller;

import java.util.List;

import org.shiftworks.domain.DocumentCriteria;
import org.shiftworks.domain.DocumentPageDTO;
import org.shiftworks.domain.ApprovalCriteria;
import org.shiftworks.domain.ApprovalListDTO;
import org.shiftworks.domain.ApprovalVO;
import org.shiftworks.domain.BoardPageDTO;
import org.shiftworks.domain.PostVO;
import org.shiftworks.domain.ScrapDTO;
import org.shiftworks.domain.ScrapVO;
import org.shiftworks.service.DocumentService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;


@RestController
@Log4j
@AllArgsConstructor
@RequestMapping("/document/*")
public class DocumentController {
	
	private DocumentService service;
	

	//내가쓴 게시물 list
	@GetMapping(value = "/myDoc/{pageNum}")
	@PreAuthorize("isAuthenticated()")
	public ModelAndView getMyDocumentListWithPaging(@PathVariable("pageNum")int pageNum, Authentication auth){
		
		//로그인한 사람만 접근 가능
		UserDetails ud = (UserDetails)auth.getPrincipal();
		//log.info(ud.getUsername());
		String emp_id = ud.getUsername();
		
		//log.info("mydoclist.........");
		DocumentCriteria cri = new DocumentCriteria();
		cri.setPageNum(pageNum);
		cri.setEmp_id(emp_id);
		
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/document/DOC_mydoclist");
		mav.addObject("pageMaker", service.getMyDocumentListWithPaging(cri));
		
		return mav;
	}
	
		//게시물 list ajax
		@GetMapping(value = "/myDoc/{pageNum}/{type}/{keyword}")
		public ResponseEntity<DocumentPageDTO> MyDocumentListWithPaging(@PathVariable("pageNum")int pageNum,
																				@PathVariable("type") String type,
																				@PathVariable("keyword")String keyword,
																				Authentication auth){
			
			//log.info("mydoclist.........");
			
			//로그인한 사람만 접근 가능
			UserDetails ud = (UserDetails)auth.getPrincipal();
			//log.info(ud.getUsername());
			String emp_id = ud.getUsername();
			
			DocumentCriteria cri = new DocumentCriteria();
			cri.setPageNum(pageNum);
			if(type.equals("empty")) {
				type = null;
			}
			if(keyword.equals("empty")) {
				keyword = null;
			}
			cri.setType(type);
			cri.setKeyword(keyword);
			cri.setEmp_id(emp_id);
			
			return new ResponseEntity <DocumentPageDTO>(service.getMyDocumentListWithPaging(cri),HttpStatus.OK);
		}
	

	
	
	//내가 쓴 게시물 상세보기
	@GetMapping(value = "/detail")
	@PreAuthorize("isAuthenticated()")
	public ModelAndView getMyDocument(@RequestParam("post_id")int post_id, Authentication auth){
		
		//log.info("mydoc........");
		
		//로그인한 사람만 접근 가능
		UserDetails ud = (UserDetails)auth.getPrincipal();
		//log.info(ud.getUsername());
		String emp_id = ud.getUsername();
		
		PostVO vo = new PostVO();
		vo.setPost_id(post_id);
		vo.setEmp_id(emp_id);
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/document/DOC_mydoc");
		mav.addObject("post", service.getMyDocument(vo));
		
		return mav;
		
	}
	
	
	//스크랩한 게시물 리스트 보기
	@GetMapping(value = "/scrap/{pageNum}")
	@PreAuthorize("isAuthenticated()")
	public ModelAndView getScrapList(@PathVariable("pageNum")int pageNum, Authentication auth){
		
		//log.info("scraplist.........");
		
		//로그인한 사람만 접근 가능
		UserDetails ud = (UserDetails)auth.getPrincipal();
		//log.info(ud.getUsername());
		String emp_id = ud.getUsername();
		
		DocumentCriteria cri = new DocumentCriteria();
		cri.setPageNum(pageNum);
		cri.setEmp_id(emp_id);
		
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/document/DOC_scraplist");
		mav.addObject("pageMaker", service.getScrapListWithPaging(cri));
		
		return mav;
	}
	
	
	//스크랩 list ajax
	@GetMapping(value = "/scrap/{pageNum}/{type}/{keyword}")
	public ResponseEntity<ScrapDTO> ScrapListWithPaging(@PathVariable("pageNum")int pageNum,
																			@PathVariable("type") String type,
																			@PathVariable("keyword")String keyword,
																			Authentication auth){
				
		//log.info("scraplist.........");
				
		//로그인한 사람만 접근 가능
		UserDetails ud = (UserDetails)auth.getPrincipal();
		//log.info(ud.getUsername());
		String emp_id = ud.getUsername();
				
		DocumentCriteria cri = new DocumentCriteria();
		cri.setPageNum(pageNum);
		if(type.equals("empty")) {
			type = null;
		}
		if(keyword.equals("empty")) {
			keyword = null;
		}
		cri.setType(type);
		cri.setKeyword(keyword);
		cri.setEmp_id(emp_id);
				
		return new ResponseEntity <ScrapDTO>(service.getScrapListWithPaging(cri),HttpStatus.OK);
	}
	
	
	//스크랩 상세보기
	@GetMapping(value = "/scrapDetail")
	@PreAuthorize("isAuthenticated()")
	public ModelAndView getScrap(@RequestParam("post_id")int post_id, Authentication auth){
		
		//log.info("scrap........");
		
		//로그인한 사람만 접근 가능
		UserDetails ud = (UserDetails)auth.getPrincipal();
		//log.info(ud.getUsername());
		String emp_id = ud.getUsername();
		
		ScrapVO vo = new ScrapVO();
		vo.setPost_id(post_id);
		vo.setEmp_id(emp_id); 
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/document/DOC_scrap");
		mav.addObject("post", service.getScrap(vo));
		
		return mav;
		
	}
	
	//부서수신함 조회
	@GetMapping(value = "/deptDoc/{pageNum}")
	@PreAuthorize("isAuthenticated()")
	public ModelAndView getDeptDocList(
					@PathVariable("pageNum") int pageNum, Authentication auth){
		
		//log.info("deptdoclist........");
		
		//로그인한 사람만 접근 가능
		UserDetails ud = (UserDetails)auth.getPrincipal();
		//log.info(ud.getUsername());
		 String emp_id = ud.getUsername();
		
		DocumentCriteria cri = new DocumentCriteria();
		cri.setPageNum(pageNum);
		cri.setEmp_id(emp_id);
		cri.setDept_id(service.getDept(emp_id));
		
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/document/DOC_deptdoclist");
		mav.addObject("pageMaker", service.deptSelectList(cri));
		
		return mav;
	}
	
	
	//부서수신함 상세보기
	@GetMapping(value = "/deptDocDetail")
	@PreAuthorize("isAuthenticated()")
	public ModelAndView getDeptDoc(@RequestParam("post_id")int post_id, Authentication auth){
		
		//log.info("deptdoc........");
		
		//로그인한 사람만 접근 가능
		UserDetails ud = (UserDetails)auth.getPrincipal();
		//log.info(ud.getUsername());
		String emp_id = ud.getUsername();
		
		PostVO vo = new PostVO();
		vo.setPost_id(post_id);
		vo.setEmp_id(emp_id); 
		vo.setDept_id(service.getDept(emp_id));
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/document/DOC_deptdoc");
		mav.addObject("post", service.deptSelect(vo));
		
		return mav;
		
	}
	
	//결재문서함 list
		@GetMapping(value = "/myApproval/{pageNum}")
		@PreAuthorize("isAuthenticated()")
		public ModelAndView getMyApprovalListWithPaging(@PathVariable("pageNum")int pageNum, Authentication auth){
			
			//로그인한 사람만 접근 가능
			UserDetails ud = (UserDetails)auth.getPrincipal();
			//log.info(ud.getUsername());
			String emp_id = ud.getUsername();
			
			//log.info("approvallist.........");
			ApprovalCriteria cri = new ApprovalCriteria();
			cri.setPageNum(pageNum);
			cri.setEmp_id(emp_id);
			
			ModelAndView mav = new ModelAndView();
			mav.setViewName("/document/DOC_myapprovallist");
			mav.addObject("pageMaker", service.approvalSelectList(cri));
			
			return mav;
		}
		
		//결재문서함 list ajax
		@GetMapping(value = "/myApproval/{pageNum}/{type}/{keyword}")
		public ResponseEntity<ApprovalListDTO> MyApprovalListWithPaging(@PathVariable("pageNum")int pageNum,
																			@PathVariable("type") String type,
																			@PathVariable("keyword")String keyword,
																			Authentication auth){
					
				//log.info("myapproval.........");
					
				//로그인한 사람만 접근 가능
				UserDetails ud = (UserDetails)auth.getPrincipal();
				//log.info(ud.getUsername());
				String emp_id = ud.getUsername();
					
				ApprovalCriteria cri = new ApprovalCriteria(); 
				cri.setPageNum(pageNum);
				if(type.equals("empty")) {
					type = null;
				}
				if(keyword.equals("empty")) {
					keyword = null;
				}
				cri.setType(type);
				cri.setKeyword(keyword);
				cri.setEmp_id(emp_id);
					
				return new ResponseEntity <ApprovalListDTO>(service.approvalSelectList(cri),HttpStatus.OK);
			}
		
		
		
		//결재문서함 상세보기
		@GetMapping(value = "/approvalDetail")
		@PreAuthorize("isAuthenticated()")
		public ModelAndView getMyApproval(@RequestParam("apr_id")int apr_id, Authentication auth){
			
			//log.info("approvaldoc........");
			
			//로그인한 사람만 접근 가능
			UserDetails ud = (UserDetails)auth.getPrincipal();
			//log.info(ud.getUsername());
			String emp_id = ud.getUsername();
			
			ApprovalVO vo = new ApprovalVO();
			vo.setApr_id(apr_id);
			vo.setEmp_id(emp_id); 
			
			
			ModelAndView mav = new ModelAndView();
			mav.setViewName("/document/DOC_myapproval");
			mav.addObject("post", service.approvalSelect(vo));
			
			return mav;
			
		}

}
