package org.shiftworks.controller;

import java.io.File;
import java.lang.ProcessBuilder.Redirect;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.shiftworks.domain.ApprovalVO;
import org.shiftworks.domain.FileVO;
import org.shiftworks.domain.ApprovalCriteria;
import org.shiftworks.domain.ApprovalPageDTO;
import org.shiftworks.domain.TempApprovalVO;
import org.shiftworks.mapper.FileMapper;
import org.shiftworks.service.ApprovalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;


@Controller
@Log4j
@RequestMapping("/approval/*")
@AllArgsConstructor
public class ApprovalController {

	@Autowired
	private ApprovalService service;
	@Autowired
	private FileMapper fileMapper;
	
	
	/*
	 * 전자결재 메인 페이지
	*/
	@GetMapping("/main")
	@PreAuthorize("isAuthenticated()")
	public String approvalMain(ApprovalCriteria cri, Model model) {
		//log.info("list" + cri);
		model.addAttribute("list", service.getList(cri));
		model.addAttribute("pageMaker", new ApprovalPageDTO(cri, service.getTotal()));
		
		return "/approval/APR_main";
	}
	
	/*
	 * 결재 리스트
	 */
	@GetMapping("/list")
	@PreAuthorize("isAuthenticated()")
	public String list(ApprovalCriteria cri, Model model) {
		//log.info("list" + cri);
		model.addAttribute("list", service.getList(cri));
		model.addAttribute("pageMaker", new ApprovalPageDTO(cri, service.getTotal()));
		
		return "/approval/APR_list";
	}
	
	
	/*
	 * 결재할 문서함 
	 */	
	@GetMapping("/receivedList")
	@PreAuthorize("isAuthenticated()")
	public String receivedList(ApprovalCriteria cri, Model model) {
		//log.info("list" + cri);
		model.addAttribute("list", service.getReceivedList(cri));
		model.addAttribute("pageMaker", new ApprovalPageDTO(cri, service.getReceivedTotal()));
		
		return "/approval/APR_receivedList";
	}
	
	/*
	 * 결재 문서 작성
	 */
	@PostMapping("/new")
	@PreAuthorize("isAuthenticated()")
	public String insert(ApprovalVO approval, RedirectAttributes rttr) {
		//log.info("insert: "+ approval);
		service.insertForm(approval);
		
		rttr.addFlashAttribute("result",approval.getApr_id());
		return "redirect:/approval/APR_list";
	}
	
	/*
	 * 결재 문서 상세보기
	 */
	@GetMapping("/{apr_id}")
	@PreAuthorize("isAuthenticated()")
	public String get(@PathVariable("apr_id") int apr_id, Model model) {
		//log.info("/get");
		model.addAttribute("approval",service.get(apr_id));
		
		return "/approval/APR_get";
	}
	
	/*
	 * 결재 수정(결재 상태 수정)
	 */ 
	@PostMapping("/receive/{apr_id}")
	@PreAuthorize("isAuthenticated()")
	public String update(@PathVariable int apr_id, ApprovalVO approval, RedirectAttributes rttr) {
		//log.info("update: "+approval);
		
		if (service.update(approval)) {
			rttr.addFlashAttribute("result", "success");			
		}
		return "redirect:/approval/list";
	}
	
	/*
	 * 결재 양식 호출
	 */
	@GetMapping("/new")
	@PreAuthorize("isAuthenticated()")
	public String insert() {
		return "/approval/APR_new";
	}
	
	/*
	 * 결재 처리(결재 상태 변경)
	 */
	@PutMapping("/sign/{apr_id}")
	@ResponseBody
	@PreAuthorize("isAuthenticated()")
	public ResponseEntity<String> updateStatus(@PathVariable int apr_id, @RequestBody ApprovalVO approval){
		//log.info("approval sign controller.......");
		
		approval.setApr_id(apr_id);
		
		//log.info("approval : " + approval);
		
		service.update(approval);
		
		return new ResponseEntity<String>("ok", HttpStatus.OK);
	}
	
	
	/*
	 임시저장 업데이트 하기
	*/
	@PostMapping("/temporory")
	@ResponseBody
	@PreAuthorize("isAuthenticated()")
	public ResponseEntity<String> temporalPost(@RequestBody TempApprovalVO vo){
		//log.info("vo : " + vo);
		//log.info("temporal.....");
		
		service.temporalApr(vo);
		
		return new ResponseEntity<String>("ok", HttpStatus.OK);
	}
	
	/*
	 임시저장 목록 불러오기
	*/
	@GetMapping(value="/temporory", produces="application/json; charSet=UTF-8")
	@ResponseBody
	@PreAuthorize("isAuthenticated()")
	public ResponseEntity<List<TempApprovalVO>> tempList(@RequestParam String emp_id){
		
		//log.info("emp_id : " + emp_id);
		
		return new ResponseEntity<List<TempApprovalVO>>(service.tempList(emp_id), HttpStatus.OK);
	
	}
	
	/*
	 임시저장 선택
	*/
	@GetMapping(value="/temporory/{temp_id}", produces="application/json; charSet=UTF-8")
	@ResponseBody
	@PreAuthorize("isAuthenticated()")
	public ResponseEntity<TempApprovalVO> tempSelect(@PathVariable int temp_id){
		
		//log.info("tempSelect.....tempId : " + temp_id);
		
		return new ResponseEntity<TempApprovalVO>(service.tempSelect(temp_id), HttpStatus.OK);
	}
	
	
	/* * * * * * * * * * * * * * * * * * *
		파일 업로드 구현
	 * * * * * * * * * * * * * * * * * * */	
	
	
	// 파일 등록
	/*
	 * @PostMapping(value="/uploadFile", produces =
	 * MediaType.APPLICATION_JSON_UTF8_VALUE)
	 * 
	 * @PreAuthorize("isAuthenticated()") public ResponseEntity<List<FileVO>>
	 * uploadFile(MultipartFile[] uploadFile) {
	 * 
	 * // 파일에 대한 정보를 리스트에 담아 리턴하기 위해 list 선언 List<FileVO> list = new
	 * ArrayList<FileVO>();
	 * 
	 * // 파일 업로드 폴더 경로 String uploadFolder = "C:\\upload";
	 * 
	 * // 날짜에 맞는 업로드 폴더 존재 확인(없을 경우 생성) File uploadPath = new File(uploadFolder,
	 * getFolder()); if(uploadPath.exists() == false) { uploadPath.mkdirs(); } //
	 * 년/월/일 경로 생성
	 * 
	 * // 업로드 파일을 하나씩 처리 for(MultipartFile m : uploadFile) {
	 * 
	 * FileVO vo = new FileVO();
	 * 
	 * // 파일 저장 경로 vo.setFile_src(getFolder());
	 * 
	 * // uuid 생성 UUID uuid = UUID.randomUUID(); // uuid 파일객체에 저장
	 * vo.setUuid(uuid.toString());
	 * 
	 * // 업로드 파일 실제 이름 String uploadFileName = m.getOriginalFilename(); // 파일명 vo객체에
	 * 저장 vo.setFile_name(uploadFileName);
	 * 
	 * // uuid + 실제 파일명 uploadFileName = uuid.toString() + "_" + uploadFileName;
	 * 
	 * try { // 파일 객체 생성 File saveFile = new File(uploadPath, uploadFileName); // 실제
	 * 파일 업로드를 진행하는 메소드 m.transferTo(saveFile);
	 * 
	 * list.add(vo); } catch (Exception e) { e.printStackTrace(); }
	 * 
	 * }
	 * 
	 * 
	 * return new ResponseEntity<List<FileVO>>(list, HttpStatus.OK);
	 * 
	 * } // end uploadFile
	 * 
	 * 
	 * // 파일 다운로드
	 * 
	 * @GetMapping(value="/download", // 다운로드가 가능하도록 MIME 타입 지정 produces =
	 * MediaType.APPLICATION_OCTET_STREAM_VALUE)
	 * 
	 * @PreAuthorize("isAuthenticated()") public ResponseEntity<Resource>
	 * downloadFile(String fileName) {
	 * 
	 * FileSystemResource resource = new FileSystemResource("C:\\upload\\" +
	 * fileName);
	 * 
	 * // 다운로드 요청한 파일이 없는 경우 if(resource.exists() == false) { return new
	 * ResponseEntity<Resource>(HttpStatus.NOT_FOUND); }
	 * 
	 * String resourceName = resource.getFilename(); // C:\\upload에 저장된 파일명에서 uuid
	 * 제거 String resourceOriginalName =
	 * resourceName.substring(resourceName.indexOf("_") + 1);
	 * 
	 * HttpHeaders headers = new HttpHeaders();
	 * 
	 * try { // 파일 다운로드 시 사용할 이름 String downloadName = new
	 * String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
	 * 
	 * 
	 * headers.add("Content-Disposition", "attachment; filename=" + downloadName);
	 * 
	 * } catch (Exception e) { e.printStackTrace(); }
	 * 
	 * return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK); }
	 * 
	 * // 메소드
	 * 
	 * // 파일 저장 폴더를 위한 메소드 private String getFolder() { SimpleDateFormat df = new
	 * SimpleDateFormat("yyyy-MM-dd"); Date date = new Date();
	 * 
	 * String str = df.format(date);
	 * 
	 * return str.replace("-", File.separator); }
	 */
	
	
	
	
	/*
	 임시저장 불러오기
	*/
//	@GetMapping(value = "/temporal")
//	public ResponseEntity<TempApprovalVO> temporalSelect(){
//		log.info("temporalSelect.....");
//		
//		String emp_id = "user1";
//		
//		return new ResponseEntity<TempApprovalVO>(service.temporalSelect(emp_id),HttpStatus.OK);
//	}
	

	/*
	 임시저장 뷰
	 session 추가 후 결재문서 작성(insert) 시 임시저장 불러오도록 구현
	*/
//	@GetMapping(value = "temporalview")
//	public ModelAndView temporalview() {
//		log.info("temporalSelect......");
//		
//		String emp_id = "user1";
//		
//		ModelAndView mav = new ModelAndView();
//		mav.setViewName("/approval/insert");
//		mav.addObject("post", service.temporalSelect(emp_id));
//		return mav;
//	}
}
