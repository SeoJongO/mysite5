package com.javaex.api.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.javaex.service.GuestbookService;
import com.javaex.vo.GuestbookVo;

@Controller
@RequestMapping(value="/api/guestbook")
public class ApiGuestbookController {

	@Autowired
	private GuestbookService guestService;
	
	@ResponseBody
	@RequestMapping(value = "/list", method = { RequestMethod.GET, RequestMethod.POST })
	public List<GuestbookVo> List() {
		System.out.println("ApiGuestbookController.List()");
		
		List<GuestbookVo> guestList = guestService.guestList();

		return guestList;
	}
	
	@ResponseBody
	@RequestMapping(value = "/write", method = { RequestMethod.GET, RequestMethod.POST })
	public GuestbookVo write(@ModelAttribute GuestbookVo guestbookVo) {
		System.out.println("ApiGuestbookController.write()");
		
		GuestbookVo resultVo = guestService.writeResultVo(guestbookVo);
		
		return resultVo;
	}
	
	@ResponseBody
	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public int delete(@ModelAttribute GuestbookVo guestbookVo) {
		System.out.println("ApiGuestbookController.delete()");
	
		int count = guestService.deleteGuest(guestbookVo);
		System.out.println(count);
		
		return count;
	}
	
}
