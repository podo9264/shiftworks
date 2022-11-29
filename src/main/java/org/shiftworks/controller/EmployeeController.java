package org.shiftworks.controller;

import org.shiftworks.domain.AccountCriteria;
import org.shiftworks.domain.EmployeeVO;
import org.shiftworks.domain.AccountPageDTO;
import org.shiftworks.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/manager/*")
@AllArgsConstructor
public class EmployeeController {
	@Autowired
	private EmployeeService service;
	
	@Autowired
	private BCryptPasswordEncoder pwdEncoder;
	
	
	@GetMapping("/list")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public String list(AccountCriteria cri, Model model) {
		model.addAttribute("list", service.getList(cri));
		
		int total = service.getTotal(cri);
		log.info("total: " + total);
		model.addAttribute("pageMaker", new AccountPageDTO(cri, total));
		
		return "/manager/MGR_list";
		
	}
	
	@GetMapping("/retiree-list")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public String retireeList(AccountCriteria cri, Model model) {
		model.addAttribute("list", service.getRetireeList(cri));
		log.info(service.getRetireeList(cri));
		int total = service.getTotalRetiree(cri);
		log.info("retiree_total: " + total);
		model.addAttribute("pageMaker", new AccountPageDTO(cri, total));
		
		return "/manager/MGR_retireeList";
		
	}

	@GetMapping("/new")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public String register() {
		
		return "/manager/MGR_new";
	}
	
	@PostMapping("/new")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public String register(EmployeeVO empVO, RedirectAttributes rttr){
		log.info("==========================");
		
		String inputPass=empVO.getPassword();
		String pwd=pwdEncoder.encode(inputPass);
		empVO.setPassword(pwd);
		
		log.info("ready register......................");
		rttr.addFlashAttribute("result", empVO.getEmp_id());
		
		return "redirect:/manager/list";
		
	}
	
	// 상세보기
	@GetMapping("/info/{emp_id}")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public String get(@PathVariable("emp_id") String emp_id, @ModelAttribute("cri") AccountCriteria cri, Model model) {
		log.info("get..............");
		model.addAttribute("employee", service.get(emp_id));	
		
		return "/manager/MGR_get";
	}
	
	// 수정을 위한 폼 이동
	@GetMapping("/{emp_id}")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public String modify(@PathVariable("emp_id") String emp_id, @ModelAttribute("cri") AccountCriteria cri, Model model) {
		log.info("get..............");
		model.addAttribute("employee", service.get(emp_id));	
		
		return "/manager/MGR_modify";
	}
	
	// 수정
	@PostMapping("/{emp_id}")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public String modify(@PathVariable("emp_id") String emp_id, EmployeeVO empVO, @ModelAttribute("cri") AccountCriteria cri,
				RedirectAttributes rttr) {
		String inputPass=empVO.getPassword();
		String pwd=pwdEncoder.encode(inputPass);
		empVO.setPassword(pwd);
		log.info("modify.............................");
		if(service.modify(empVO)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		
		return "redirect:/manager/list";
	}
	
	@PostMapping("/removal/{emp_id}")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public String remove(@RequestParam("emp_id") String emp_id, 
			@ModelAttribute AccountCriteria cri, RedirectAttributes rttr) {
		if(service.remove(emp_id)) {
			rttr.addAttribute("result", "success");
		}		
		return "redirect:/manager/list";
	}
	
	
}
