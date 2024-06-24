//-------------------------------------------------------------
// SYNOPSYS CONFIDENTIAL - This is an unpublished, proprietary work of 
// Synopsys, Inc., and is fully protected under copyright and trade 
// secret laws. You may not view, use, disclose, copy, or distribute this 
// file or any information contained herein except pursuant to a valid 
// written license from Synopsys. 
//-------------------------------------------------------------

#ifdef VCSMX
#ifndef VCS
#define VCS
#endif
#endif

#ifdef __cplusplus
extern "C" {
#endif

#include "vpi_user.h"
#include "veriuser.h"
#include "sv_vpi_user.h"

#ifdef VCS
   #include "vcs_vpi_user.h"
#endif

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>

#ifdef VCS
// to supress error msg when turn on -exitstatus 
extern vpiHandle silent_vpi_handle_by_name(char* name,vpiHandle scope);
#define VERDI_UVM_VPI_HANDLE_BY_NAME silent_vpi_handle_by_name
#else
#define VERDI_UVM_VPI_HANDLE_BY_NAME vpi_handle_by_name
#endif 

struct rsrc_msg_struct {
  char* scope_name;
  char* field_name;
  char* type_name;
  char* action;
  char* accessor;
  char* resource;
};

char *concat_strings(char *dest_str, char *source_str); 
char *remove_class_backslash_parameters(char *src_str);

// Replaced by new function: parse_phase_msg_by_chandle 
/*
int parse_phase_msg(const char* msg, char*& domain, char*& schedule, char*& phase) {
   int _num_dots=0, _domain_len, _sch_len, _phase_len;
   const char *_dot_1st_ch=NULL, *_dot_2nd_ch=NULL;
   if(msg==NULL)
      return 0;

   _dot_1st_ch = strchr(msg, '.');

   if(_dot_1st_ch)
      _dot_2nd_ch = strchr((_dot_1st_ch+1), '.');

   if(_dot_1st_ch==NULL) {
      domain = (char*) malloc(sizeof(char) * (strlen(msg) + 1));
      strncpy(domain, msg, strlen(msg));
      domain[strlen(msg)] = '\0';
      phase = domain;
      return 1;
   }

   _domain_len = _dot_1st_ch - msg;
   domain = (char*) malloc(sizeof(char) * (_domain_len+1));
   strncpy(domain, msg, _domain_len);
   domain[_domain_len] = '\0';

   if(_dot_1st_ch && _dot_2nd_ch==NULL) {
      _phase_len = strlen(msg) - _domain_len - 1;

      phase = (char*) malloc(sizeof(char) * (_phase_len+1));
      strncpy(phase, (_dot_1st_ch+1), _phase_len);
      phase[_phase_len] = '\0';
      return 1;
   }

   _sch_len = _dot_2nd_ch - _dot_1st_ch - 1;
   _phase_len = strlen(msg) - _domain_len - _sch_len - 2;

   schedule = (char*) malloc(sizeof(char) * (_sch_len+1));
   phase = (char*) malloc(sizeof(char) *(_phase_len+1));

   strncpy(schedule, (_dot_1st_ch+1), _sch_len);
   schedule[_sch_len] = '\0';
   strncpy(phase, (_dot_2nd_ch+1), _phase_len);
   phase[_phase_len] = '\0';
   return 1;
}
*/

int parse_phase_msg_by_chandle(const char* msg, void*& ptr_domain, void*& ptr_schedule, void*& ptr_phase) {
   int _domain_len, _sch_len, _phase_len;
   const char *_dot_1st_ch=NULL, *_dot_2nd_ch=NULL;
   char *domain, *schedule, *phase;
   ptr_domain = NULL, ptr_schedule=NULL, ptr_phase=NULL;

   if(msg==NULL)
      return 0;

   _dot_1st_ch = strchr(msg, '.');

   if(_dot_1st_ch)
      _dot_2nd_ch = strchr((_dot_1st_ch+1), '.');

   if(_dot_1st_ch==NULL) {
      domain = (char*) malloc(sizeof(char) * (strlen(msg) + 1));
      strncpy(domain, msg, strlen(msg));
      domain[strlen(msg)] = '\0';

      phase = (char*) malloc(sizeof(char) * (strlen(msg) + 1));
      strncpy(phase, msg, strlen(msg));
      phase[strlen(msg)] = '\0';

      ptr_domain = (void*) domain;
      ptr_phase = (void*) phase;
      return 1;
   }

   _domain_len = _dot_1st_ch - msg;
   domain = (char*) malloc(sizeof(char) * (_domain_len+1));
   strncpy(domain, msg, _domain_len);
   domain[_domain_len] = '\0';

   if(_dot_1st_ch && _dot_2nd_ch==NULL) {
      _phase_len = strlen(msg) - _domain_len - 1;

      phase = (char*) malloc(sizeof(char) * (_phase_len+1));
      strncpy(phase, (_dot_1st_ch+1), _phase_len);
      phase[_phase_len] = '\0';
      
      ptr_domain = (void*) domain;
      ptr_phase = (void*) phase;
      return 1;
   }

   _sch_len = _dot_2nd_ch - _dot_1st_ch - 1;
   _phase_len = strlen(msg) - _domain_len - _sch_len - 2;

   schedule = (char*) malloc(sizeof(char) * (_sch_len+1));
   phase = (char*) malloc(sizeof(char) *(_phase_len+1));

   strncpy(schedule, (_dot_1st_ch+1), _sch_len);
   schedule[_sch_len] = '\0';
   strncpy(phase, (_dot_2nd_ch+1), _phase_len);
   phase[_phase_len] = '\0';
   //
   ptr_domain = (void*) domain;
   ptr_schedule = (void*) schedule;
   ptr_phase = (void*) phase;
   return 1;
}

int parse_rsrc_msg(const char* msg, struct rsrc_msg_struct& msg_struct) {
   const char *_first_tick, *_second_tick, *_dot_pos, *_1st_left_parentheses, *_1st_right_parentheses=NULL;
   char *_scope_n_field;

   if(msg==NULL)
      return 0;

   _first_tick = strchr(msg, '\'');

   if(_first_tick==NULL)
      return 0;

   _second_tick = strchr((_first_tick + 1), '\'');

   if(_second_tick==NULL)
      return 0;

   int _full_scope_len;
   _full_scope_len = _second_tick - _first_tick - 1;

   _scope_n_field = (char*) malloc(sizeof(char) * (_full_scope_len+1));
   strncpy(_scope_n_field, (_first_tick+1), _full_scope_len);
   _scope_n_field[_full_scope_len] = '\0';
   _dot_pos = strrchr(_scope_n_field, '.');

   int _scope_len=0, _field_len;

   if(_dot_pos!=NULL)
      _scope_len = _dot_pos - _scope_n_field;
   else
      _scope_len = _full_scope_len;

   _field_len = strlen(_scope_n_field) - _scope_len -1;

   if(_scope_len>0) {
      msg_struct.scope_name = (char*) malloc(sizeof(char) * (_scope_len + 1));
      strncpy(msg_struct.scope_name, _scope_n_field, _scope_len);
      msg_struct.scope_name[_scope_len] = '\0';
   }

   if(_field_len>0) {
      msg_struct.field_name = (char*) malloc(sizeof(char) * (_field_len + 1));
      strncpy(msg_struct.field_name, (_dot_pos+1), _field_len);
      msg_struct.field_name[_field_len] = '\0';
   }

   free(_scope_n_field);

   int _type_len=0, _matched_parentheses=0;
   const char * _nxt_parentheses;

   _1st_left_parentheses = strchr(_second_tick, '(');

   if(_1st_left_parentheses==NULL)
      return 0;

   const char *_end_msg;

   _end_msg = msg + strlen(msg);
   _nxt_parentheses = _1st_left_parentheses + 1;
   _matched_parentheses = 1;

   while(_matched_parentheses>0 && _nxt_parentheses < _end_msg) {

      if(_nxt_parentheses[0] == '(') {
         _matched_parentheses++;
      } else  if(_nxt_parentheses[0] == ')') {
         _matched_parentheses--;

         if(_matched_parentheses>0) {
            _nxt_parentheses++;
            continue;
         }
         _1st_right_parentheses = _nxt_parentheses;
         _nxt_parentheses = _end_msg;
      }
      _nxt_parentheses++;
   }


   if(_1st_right_parentheses==NULL || _1st_right_parentheses==_end_msg)
      return 0;

   _type_len = _1st_right_parentheses - _1st_left_parentheses - 6;
   if(_type_len>0) {
      msg_struct.type_name = (char *) malloc(sizeof(char) * (_type_len + 1));
      strncpy(msg_struct.type_name, (_1st_left_parentheses + 6), _type_len);
      msg_struct.type_name[_type_len] = '\0';
   }

   const char *_act_end;
   int _act_len=0;
   _act_end = strstr(_1st_right_parentheses, " by ");

   if(_act_end!=NULL)
      _act_len = _act_end - _1st_right_parentheses- 2;

   if(_act_len>0) {
      msg_struct.action = (char*) malloc(sizeof(char) * (_act_len + 1));
      strncpy(msg_struct.action, (_1st_right_parentheses+2), _act_len);
      msg_struct.action[_act_len] = '\0';
   }

   const char *_equal_pos=NULL;
   int _accessor_len=0, _rsrc_val_len=0;

   if(_act_end!=NULL)
      _equal_pos = strchr(_act_end, '=');

   if(_equal_pos!=NULL)
      _accessor_len = _equal_pos - _act_end - 5;

   if(_accessor_len > 0) {
      msg_struct.accessor = (char*) malloc(sizeof(char) * (_accessor_len + 1));
      strncpy(msg_struct.accessor, (_act_end +4), _accessor_len);
      msg_struct.accessor[_accessor_len] = '\0';
   }

   if(_equal_pos!=NULL)
      _rsrc_val_len = strlen(msg) - (_equal_pos - msg + 1) - 1;
   else 
      _rsrc_val_len = strlen(msg) - (_act_end + strlen(_act_end) - msg + 1);

   if(_rsrc_val_len>0) {
      msg_struct.resource = (char*) malloc(sizeof(char) * (_rsrc_val_len + 1));
      strncpy(msg_struct.resource, (_equal_pos+2), _rsrc_val_len);
      msg_struct.resource[_rsrc_val_len] = '\0';
   }

   return 1;
}

int  find_substr_by_C(const char* org_str, const char* s_str) {
   const char *f_str;
   int _pos;

   if(org_str==NULL || s_str==NULL)
      return -1;

   f_str = strstr(org_str, s_str);

   if(!f_str)
     return -1;

   _pos = f_str - org_str;
   return _pos;
}

char* retrieve_simple_array_name(const char *_name_w_idx) {
   char *pch, *_name_wo_idx=NULL;
   size_t _name_w_idx_len, _new_len, _idx, _nxt_idx;

   _name_w_idx_len = strlen(_name_w_idx);

   if(_name_w_idx==NULL || _name_w_idx[0]=='\\' || _name_w_idx[_name_w_idx_len-1] != ']') {
      _name_wo_idx = (char*) malloc((_name_w_idx_len + 1) * sizeof(char));
      strncpy(_name_wo_idx, _name_w_idx, _name_w_idx_len);
      _name_wo_idx[_name_w_idx_len] = '\0';
      return _name_wo_idx;
   }
  
   pch = (char*) strrchr(_name_w_idx, '[');
   _new_len = pch - _name_w_idx;

   do { 

      _nxt_idx = _new_len -1;
      if(_name_w_idx[_nxt_idx] != ']') {
         _name_wo_idx = (char *) malloc((_new_len + 1) * sizeof(char));
         strncpy(_name_wo_idx, _name_w_idx, _new_len);
         _name_wo_idx[_new_len] = '\0';
         return _name_wo_idx;
      } else {
        _new_len = 0;
        for(_idx=_nxt_idx-1; _idx>=0 && _new_len==0; _idx--) {
           if(_name_w_idx[_idx]!='[')
              continue;
           _new_len = _idx + 1;
        }
     }
   } while(_new_len!=0);
    
   _name_wo_idx = (char*) malloc((_name_w_idx_len + 1) * sizeof(char));
   strncpy(_name_wo_idx, _name_w_idx, _name_w_idx_len);
   _name_wo_idx[_name_w_idx_len] = '\0';
   return _name_wo_idx;
}

char* remove_array_index(const char *_name_w_idx, void *&_ptr) {
   char *_simple_array_name;

   _simple_array_name = retrieve_simple_array_name(_name_w_idx);
   _ptr = (void*) _simple_array_name;
   return _simple_array_name;

}

/*  Merge into its only caller function: is_of_type_name
vpiHandle get_classdefn_from_extends(vpiHandle class_extends) {

   vpiHandle _class_typespec = NULL, _class_defn = NULL;
   if(class_extends==NULL)
      return NULL;

   if(vpi_get(vpiType, class_extends) != vpiExtends) 
      return class_extends;

   _class_typespec = vpi_handle(vpiClassTypespec, class_extends);

   if(_class_typespec==NULL)
      return NULL;

   _class_defn = vpi_handle(vpiClassDefn, _class_typespec);

   if(_class_typespec)
      vpi_release_handle(_class_typespec);

   return _class_defn;  // note: caller function need to release this vpi handle 
}
*/

bool is_of_type_name(vpiHandle input_class_defn, const char* chk_type_name) {
   vpiHandle ext_type=NULL, base_class_defn=NULL;
   char *type_name=NULL;
   bool is_rtn = FALSE;
   size_t  chk_type_name_len = 0;

   if(input_class_defn == NULL)
      return is_rtn;

   //class_defn = get_classdefn_from_extends(class_defn);
   //
   vpiHandle class_defn = NULL, _class_typespec = NULL;
   bool b_need_release = FALSE; 
   if(input_class_defn) {
      if(vpi_get(vpiType, input_class_defn) != vpiExtends) {
         class_defn = input_class_defn;
      }else {
         _class_typespec = vpi_handle(vpiClassTypespec, input_class_defn);
         if(_class_typespec) {
            class_defn = vpi_handle(vpiClassDefn, _class_typespec);
         }
         vpi_release_handle(_class_typespec);
      }
   }

   if(class_defn) {
      type_name = vpi_get_str(vpiName, class_defn);
      // input_class_defn will be released by caller funciton, prevent release it twice
      b_need_release = (vpi_compare_objects(class_defn, input_class_defn)!=1) ? TRUE : FALSE;
   }

   if(type_name==NULL || chk_type_name==NULL) {
      if(b_need_release) 
         vpi_release_handle(class_defn);
      return is_rtn;
   }


   if(!strcmp(type_name,  chk_type_name)) {
      is_rtn = TRUE;
      if(b_need_release) 
         vpi_release_handle(class_defn);
      return is_rtn;
   }

   chk_type_name_len = strlen((const char*) chk_type_name);

   if(strlen(type_name) >= (chk_type_name_len + 2) && 
      type_name[0] == '\\' && type_name[chk_type_name_len+1]=='#' &&
      strncmp((type_name+1), chk_type_name, chk_type_name_len)==0 ) {

      if(b_need_release)
         vpi_release_handle(class_defn);

      is_rtn = TRUE;
      return is_rtn;
   }

   ext_type = vpi_handle(vpiExtends, class_defn);

   if(ext_type!=NULL && vpi_get(vpiType, ext_type)==vpiExtends) 
      base_class_defn = vpi_handle(vpiClassDefn, ext_type);
   else
      base_class_defn = ext_type;

   if(base_class_defn!=NULL) 
      is_rtn = is_of_type_name(base_class_defn, chk_type_name);

   if(ext_type!=NULL) {
      if(base_class_defn!=NULL && vpi_compare_objects(base_class_defn,ext_type)!=1 )
         vpi_release_handle(base_class_defn);
      vpi_release_handle(ext_type);
   }
   if(b_need_release)
      vpi_release_handle(class_defn);

   return is_rtn;
}

bool is_port_component(vpiHandle class_defn) { return is_of_type_name(class_defn, "uvm_port_component_base"); }
bool is_component(vpiHandle class_defn)      { return is_of_type_name(class_defn, "uvm_component"); }

char *reformat_protected_scope_name(char *src) {
   char *bch=NULL, *dch=NULL, *ech=NULL, *rstr=NULL;
   int pkg_size=0, class_size, fsize;

   bch = strchr(src, '\\');
   dch = strstr(src, "::");

   if(dch) {
      pkg_size = bch ? (dch - bch -1) : dch - src;
   }

   if(bch)
      ech = strrchr(src, ' ');
   else
      ech = strrchr(src, '@');

   if(dch)
      class_size = ech - (dch + 2);
   else
      class_size = bch ? (ech - bch -1) : (ech - src);

   if(pkg_size)
      fsize = pkg_size+class_size+2;
   else
      fsize = class_size+1;

   rstr = (char*) malloc(fsize * sizeof(char));
   if(!rstr)
      return NULL;

   if(bch && pkg_size) {
      rstr = strncpy(rstr, bch+1, pkg_size);
      rstr[pkg_size] = '\0';
      rstr = strcat(rstr, (char*) ".");
      rstr = strncat(rstr, dch+2, class_size);
   } else if(pkg_size) {
      rstr = strncpy(rstr, src, pkg_size);
      rstr[pkg_size] = '\0';
      rstr = strcat(rstr, (char*) ".");
      rstr = strncat(rstr, dch+2, class_size);
   }
 
   rstr[fsize-1] = '\0';
   return rstr; 
}

char *remove_class_backslash_parameters(char *src_str) {
   char *dest_str, *bch, *pch;
   size_t _dest_size;

   bch = strchr(src_str, '\\');
   pch = strchr(src_str, '#');

   if(pch)
      _dest_size = pch - src_str + 1;
   else
      _dest_size = strlen(src_str) + 1;

   if(bch)
      _dest_size = (pch) ? _dest_size - 1 : _dest_size - 2;

   dest_str = (char*) malloc(_dest_size * sizeof(char));

   if(bch) {
      strncpy(dest_str, src_str+1, (_dest_size-1));
   } else {
      strncpy(dest_str, src_str, (_dest_size-1));
   }
   dest_str[_dest_size-1] = '\0';
   return dest_str;
 
}

char* retrieve_simple_class_by_classdefn(vpiHandle class_defn, char** class_library, char** class_full_name) {
   vpiHandle pkg_handle=NULL;
   char *classPkg=NULL, *simple_class=NULL, *class_lib=NULL, *resolved_class_name=NULL;

   if(vpi_get(vpiType, class_defn) != vpiClassDefn)
      return NULL;

   pkg_handle = vpi_handle(vpiScope, class_defn);

   if(pkg_handle) {
      class_lib = vpi_get_str(vpiLibrary, pkg_handle);
      classPkg = concat_strings(classPkg, vpi_get_str(vpiDefName, pkg_handle));
   }

   if(class_lib) {
      (*class_library) = (char*) malloc(sizeof(char) * (strlen(class_lib) + 1));
      strcpy((*class_library), class_lib);
      (*class_library)[strlen(class_lib)] = '\0';
   } else
      (*class_library) = NULL;

   resolved_class_name = vpi_get_str(vpiName, class_defn);

   if(resolved_class_name) {
      char *_tmp_str=NULL;
      size_t _tmp_size=0;

      simple_class = remove_class_backslash_parameters(resolved_class_name);

      if(classPkg) {
         _tmp_size = strlen(classPkg) + strlen(simple_class) + 2;
         _tmp_str  = (char*) malloc(_tmp_size * sizeof(char));

         if(simple_class) 
            sprintf(_tmp_str, "%s.%s", classPkg, simple_class);

         free(classPkg);
         if(simple_class)
            free(simple_class);

         classPkg = _tmp_str;

      } else {
         classPkg = simple_class;
      }
   }
  
   resolved_class_name = vpi_get_str(vpiFullName, class_defn);
   if(resolved_class_name) {
      (*class_full_name) = (char*) malloc (sizeof(char) * (strlen(resolved_class_name) + 1));
      strcpy((*class_full_name), resolved_class_name);
      (*class_full_name)[strlen(resolved_class_name)] = '\0';
   }


   if(pkg_handle)
      vpi_release_handle(pkg_handle);

   return classPkg;
}

char* retrieve_port_objid(vpiHandle port_obj, char** portClass, char** lib_name) {

   vpiHandle prt=NULL, prtDefn=NULL, port_handle=NULL;
   char *prtObjIdStr=NULL;

#ifdef VCS
   char prtObjId[10];
#endif

   port_handle = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "m_port", port_obj);

   if(port_handle) { 
     
      if(vpi_get(vpiType, port_handle)!=vpiClassObj) 
         prt = vpi_handle(vpiClassObj, port_handle);
      else
         prt = port_handle;

      if(prt)
         prtDefn = vpi_handle(vpiClassDefn, prt);

      if(prtDefn) {
         (*portClass)   = retrieve_simple_class_by_classdefn(prtDefn, lib_name, &prtObjIdStr);

#ifdef VCS
         sprintf(prtObjId, "@%ld", (long int)vpi_get(vpiId, prt));
         prtObjIdStr = concat_strings(prtObjIdStr, prtObjId); 
#endif

      } 
   }

   if(prt)
      vpi_release_handle(prt);
   if(prtDefn)
      vpi_release_handle(prtDefn);
   if(port_handle)
      vpi_release_handle(port_handle);

   return prtObjIdStr;
}


char *concat_strings(char *dest_str, char *source_str) {
   int destLen=0, srcLen=0;
   char *tmp_str;

   if(!source_str)
      return NULL;

   destLen = dest_str ? strlen(dest_str) : 0;
   srcLen  = source_str ? strlen(source_str) : 0;

   if(srcLen==0)
      return dest_str;

   if(destLen==0 ) {
      tmp_str = (char *) malloc((srcLen+1) * sizeof(char));
      strcpy(tmp_str, source_str);
   } else {
      tmp_str = (char *) realloc(dest_str, (destLen+srcLen+1) * sizeof(char));
      strncat(tmp_str, source_str, srcLen);
      tmp_str[destLen+srcLen] = '\0';
   }

   return tmp_str;
}

char *verdi_upper_scope(const char *component_name, void *&_upper_scope_str) {

   char *tmp_str = NULL;
   const char *last_dot=NULL;
   int cpy_len=0;

   _upper_scope_str = NULL;
   last_dot = strrchr(component_name, '.');

   if (last_dot==NULL) 
       return NULL;

   cpy_len = last_dot - component_name;

   if(tmp_str) {
      free((void *) tmp_str);
      tmp_str = NULL;
   }

   if(cpy_len>0) 
      tmp_str = (char *) malloc((cpy_len+1) * sizeof(char));

   if(tmp_str)  {
      strncpy(tmp_str, component_name, cpy_len);
      tmp_str[cpy_len] = '\0';
      _upper_scope_str = (void*) tmp_str;
      return tmp_str;
   }

   return NULL;
}

char* verdi_dpi_get_c_string_by_chandle(void* c_str_ptr) {
   return (char*) c_str_ptr;
}

void verdi_dpi_free_c_string_by_chandle(void* c_str_ptr) {
   if(c_str_ptr)
      free(c_str_ptr);
}

extern void pli_trans_add_vif_attr(const char *scope_name, int idx, char* attr_val, int streamId);
extern void pli_trans_add_class_name_attr(const char *scope_name, char* attr_val, int streamId);



bool check_is_sequencer() {
   vpiHandle hFrame=NULL, hScope=NULL, hClassObj=NULL, hObjType=NULL;;
   bool rtnVal =FALSE; 

   hFrame = vpi_handle(vpiFrame, 0);
   hScope  = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "verdi_cur_component", hFrame);

   if(!hScope) {
	  if(hFrame)
		vpi_release_handle(hFrame);
      return rtnVal;
   }

   if(vpi_get(vpiType, hScope)!=vpiClassObj)
      hClassObj = vpi_handle(vpiClassObj, hScope);
   else
      hClassObj = hScope;

   if(hClassObj)
      hObjType = vpi_handle(vpiClassDefn, hClassObj);

   if(hObjType) {
	   rtnVal = is_of_type_name(hObjType, "uvm_sequencer");
   }

   if(hFrame)
      vpi_release_handle(hFrame);
   if(hScope){
      if(hClassObj && vpi_compare_objects(hClassObj, hScope)!=1)
         vpi_release_handle(hClassObj);
      vpi_release_handle(hScope);
   }
   if(hObjType)
      vpi_release_handle(hObjType);

   return rtnVal;
}

int verdi_dump_component_interface(const char *scope_name, int streamId) {

   char *vifVarName=NULL, *class_name=NULL;
   vpiHandle hIter=NULL, hClassObj=NULL, hVif=NULL, hVifActual=NULL;
   char *vifName=NULL;
   vpiHandle hFrame=NULL, hScope=NULL, hObjType=NULL;
   char *object_type_name=NULL;
   int ary_size;
   vpiHandle ch_itr_arr[2];
   int ch_itr_arr_num = 1;
   vpiHandle hChildren=NULL;

#ifdef INCA
   PLI_INT32 vpi_type;
#endif

   ary_size = 0;
   hFrame = vpi_handle(vpiFrame, 0);
   hScope  = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "verdi_cur_component", hFrame);
   
   vpi_release_handle(hFrame);

   if(!hScope)
      return ary_size;

   if(vpi_get(vpiType, hScope)!=vpiClassObj)
      hClassObj = vpi_handle(vpiClassObj, hScope);
   else
      hClassObj = hScope;

   if(hClassObj)
      hObjType = vpi_handle(vpiClassDefn, hClassObj);
  
   if(hObjType && is_component(hObjType)) {
	  object_type_name = vpi_get_str(vpiName, hObjType);
   }else {
	  if( vpi_compare_objects(hClassObj, hScope)!=1 /*diff*/)
		  vpi_release_handle(hClassObj);
	  vpi_release_handle(hScope);
	  return ary_size; 
   }

   if(object_type_name)
      class_name = concat_strings(class_name, object_type_name);

   if(class_name) {
      pli_trans_add_class_name_attr(scope_name, class_name, streamId);
      free(class_name);
      class_name = NULL;
   }
   

#ifdef INCA

   hIter = vpi_iterate(vpiVariables, hClassObj);
   while(( hVif = vpi_scan(hIter))) {

      if(vpi_get(vpiType, hVif) != vpiVirtualInterfaceVar) {
		 vpi_release_handle(hVif);
         continue;
	  }

      hVifActual = vpi_handle(vpiActual, hVif);

      if(hVifActual==NULL) 
         continue;

      if(ary_size>0) { 
         pli_trans_add_vif_attr(scope_name, ary_size, vifVarName, streamId);
         free(vifVarName);
         vifVarName = NULL;
      }

      vifName = vpi_get_str(vpiFullName, hVifActual);
      vifVarName = concat_strings(vifVarName, vifName);
      ary_size++;
	  
	  vpi_release_handle(hVif);
	  vpi_release_handle(hVifActual);
   }

#endif

#ifdef VCS

   // Need to consider VIP. Specific object may contain virtual interface
   ch_itr_arr[0] = NULL;
   ch_itr_arr[1] = NULL;

   ch_itr_arr[0] = vpi_iterate(vpiVirtualInterfaceVar, hClassObj);
   if(!ch_itr_arr[0]){
      hChildren = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "common", hClassObj);
      if (hChildren){
          ch_itr_arr[0] = vpi_iterate(vpiVirtualInterfaceVar, hChildren);
          if(!ch_itr_arr[0]){
             ch_itr_arr[0] = vpi_iterate(vpiVariables, hClassObj);
          }
      }else{
          hChildren = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "cfg", hClassObj);
          if (hChildren){
              ch_itr_arr[0] = vpi_iterate(vpiVirtualInterfaceVar, hChildren);
              if(!ch_itr_arr[0]){
                 ch_itr_arr[0] = vpi_iterate(vpiVariables, hClassObj);
              }
          } else {
              ch_itr_arr[0] = vpi_iterate(vpiVariables, hClassObj);
          }
      }
   }else{
      hChildren = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "cfg", hClassObj);
      if (hChildren){
          ch_itr_arr[1] = vpi_iterate(vpiVirtualInterfaceVar, hChildren);
          if(!ch_itr_arr[1]){
             ch_itr_arr[1] = vpi_iterate(vpiVariables, hClassObj);
          }
      } else {
          hChildren = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "common", hClassObj);
          if (hChildren){
              ch_itr_arr[1] = vpi_iterate(vpiVirtualInterfaceVar, hChildren);
              if(!ch_itr_arr[1]){
                 ch_itr_arr[1] = vpi_iterate(vpiVariables, hClassObj);
              }
          } else {
              ch_itr_arr[1] = vpi_iterate(vpiVariables, hClassObj);
          }
      }      
   }

   if (ch_itr_arr[1]!=NULL)
       ch_itr_arr_num = 2;

   for (int i=0;i<ch_itr_arr_num;i++){
        hIter = ch_itr_arr[i];
   while(( hVif = vpi_scan(hIter))) {

      if(vpi_get(vpiType, hVif) != vpiVirtualInterfaceVar &&
         vpi_get(vpiType, hVif) != vpiRefObj){
         continue;
      }

      hVifActual = vpi_handle(vpiActual, hVif);

      if(hVifActual==NULL) {
		 vpi_release_handle(hVif);
         continue;
	  }

      if(ary_size > 0) {
         pli_trans_add_vif_attr(scope_name, ary_size-1, vifVarName, streamId);
         free(vifVarName);
         vifVarName = NULL;
      }

      vifName    = vpi_get_str(vpiFullName, hVifActual);
      vifVarName = concat_strings(vifVarName, vifName);
      ary_size++;
	  
	  vpi_release_handle(hVif);
	  vpi_release_handle(hVifActual);
	  
   }
   }
#endif

   if(ary_size==1)
      pli_trans_add_vif_attr(scope_name, -1, vifVarName, streamId);
   else
      pli_trans_add_vif_attr(scope_name, ary_size-1, vifVarName, streamId);

   if(vifVarName)
      free(vifVarName);
  
   if( vpi_compare_objects(hScope, hClassObj)!=1 /*diff*/)
	   vpi_release_handle(hClassObj);
   vpi_release_handle(hScope);
   vpi_release_handle(hObjType);
   
   return ary_size;
}

char *val2string(p_vpi_value value_p, int bit_size) {
   static char *rntVal = NULL;
   int  valStrLen, numvals, idx_i, idx_j, bit_a, bit_b, abLen=0, shiftLen;

   if(rntVal!=NULL) 
      free((void *) rntVal);

   switch(value_p->format) {
      case vpiIntVal:
          rntVal = (char *) malloc(sizeof(char) * 256);
          sprintf(rntVal, "'d%d", value_p->value.integer);
          return rntVal;
      case vpiScalarVal:
          rntVal = (char *) malloc(sizeof(char) * 256);
          sprintf(rntVal, "'d%d", value_p->value.scalar);
          return rntVal;

      case vpiBinStrVal:
      case vpiOctStrVal:
      case vpiDecStrVal:
      case vpiHexStrVal:
      case vpiStringVal:
          valStrLen = strlen(value_p->value.str);
          rntVal = (char *) malloc(sizeof(char) * valStrLen);
          sprintf(rntVal, "%s", value_p->value.str);
          return rntVal;
      
      case vpiRealVal:
          rntVal = (char *) malloc(sizeof(char) * 256);
          sprintf(rntVal, "%f", value_p->value.real);
          return rntVal;

      case vpiVectorVal:

          numvals = (bit_size -1)/32 + 1;
          rntVal = (char *) malloc(sizeof(char) * bit_size);
          strcpy(rntVal, (char *)  "'b");

          for(idx_i=0; idx_i<numvals; idx_i++) {

             if(abLen==0) 
                abLen = sizeof(value_p->value.vector[idx_i].aval) * 8;

             for(idx_j=0; idx_j<abLen && (idx_i* abLen + idx_j)<bit_size; idx_j++) {

                shiftLen = abLen - idx_j - 1;
                bit_a = value_p->value.vector[idx_i].aval & (1 << shiftLen);
                bit_b = value_p->value.vector[idx_i].bval & (1 << shiftLen);

                if(bit_b==0) {
                   if(bit_a==0)
                      strcat(rntVal, (char *) "0");
                   else 
                      strcat(rntVal, (char *) "1");
                } else  {
                   if(bit_a==0)
                      strcat(rntVal, (char *) "z");
                   else 
                      strcat(rntVal, (char *) "x");
                }
             }
          }
          return rntVal;
      default:
          return NULL;
   } 
}

char *verdi_dump_resource_value(char *rsrc, void *&_rtn_str_ptr) {

   vpiHandle hIter=NULL, hClassObj=NULL, hVal=NULL;
   vpiHandle hFrame=NULL, hScope=NULL;
   char *varName;
   PLI_INT32 vpi_type;
   p_vpi_value value_p;
   char *tmp_str, *rtn_str;
   
   _rtn_str_ptr = NULL;

   hFrame = vpi_handle(vpiFrame, 0);
   hScope = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) rsrc, hFrame);

   hClassObj = vpi_handle(vpiClassObj, hScope); 

   hIter = vpi_iterate(vpiVariables, hClassObj);
   
   //
   if(hFrame)
	   vpi_release_handle(hFrame);
   if(hScope)
	   vpi_release_handle(hScope);
   if(hClassObj)
	   vpi_release_handle(hClassObj);
   
   
   while( (hVal = vpi_scan(hIter)) ) {
      vpi_type = vpi_get(vpiType, hVal);

      varName = vpi_get_str(vpiName, hVal);
      if(strcmp(varName, "val")) {
		 vpi_release_handle(hVal);
         continue;
	  }

      switch(vpi_type) {
        case vpiClassVar: // Handle class objects
            hClassObj = vpi_handle(vpiClassObj, hVal); 
            tmp_str = vpi_get_str(vpiScope, hClassObj);
            rtn_str = (char*) malloc( sizeof(char) * (strlen(tmp_str)+1));
            strncpy(rtn_str, tmp_str, strlen(tmp_str));
            rtn_str[strlen(tmp_str)] = '\0';
            _rtn_str_ptr = (void*) rtn_str; 
            //
            vpi_release_handle(hClassObj);
            vpi_release_handle(hVal);
            return rtn_str;

        case vpiVirtualInterfaceVar:
        case vpiRefObj: // Handle interface
            hClassObj = vpi_handle(vpiActual, hVal); 
            tmp_str = vpi_get_str(vpiFullName, hClassObj);
            rtn_str = (char*) malloc( sizeof(char) * (strlen(tmp_str)+1));
            strncpy(rtn_str, tmp_str, strlen(tmp_str));
            rtn_str[strlen(tmp_str)] = '\0';
            _rtn_str_ptr = (void*) rtn_str; 
            //
            vpi_release_handle(hClassObj);
            vpi_release_handle(hVal);
            return rtn_str; 

        default:
            value_p = (p_vpi_value) malloc(sizeof(s_vpi_value));
            value_p->format = vpiObjTypeVal;
            vpi_get_value(hVal, value_p);
            free((void *)value_p);
            rtn_str = val2string(value_p, vpi_get(vpiSize, hVal));
            _rtn_str_ptr = (void*) rtn_str;
            //
            vpi_release_handle(hVal);
            return rtn_str;
      }

   }
   
   if(hIter)
	   vpi_release_handle(hIter);

   return NULL;
}


extern int pli_dhier_begin_event(char *streamN);
extern void pli_dhier_set_label(int handle, char *label);
extern void pli_dhier_add_attribute(int handle, const char *attr_name, const char *attr_value);
extern void pli_dhier_add_attribute_int(int handle, const char *attr_name, int attr_value);
extern void pli_dhier_end_event(int handle);

vpiHandle retrieve_component_name_handle(vpiHandle current_obj, char* _mname) {
   vpiHandle _hTypespec=NULL, _hVar=NULL;
   vpiHandle _hTmp=NULL;

   _hTypespec = vpi_handle(vpiClassTypespec, current_obj);

   do {
      _hVar = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) _mname, _hTypespec);

      if(_hVar) {
         break;
      }
      
	  _hTmp = _hTypespec;
     _hTypespec = vpi_handle(vpiExtends, _hTypespec);
	  vpi_release_handle(_hTmp);

   } while(_hTypespec);
   
   if(_hTypespec)
		vpi_release_handle(_hTypespec); 
	
   return _hVar;
}

void retrieve_comp_intf(vpiHandle hClassObj, vpiHandle hClassDefn) {

   vpiHandle hChildren=NULL, hChIter=NULL, hName=NULL, hVif=NULL, hVifActual=NULL, hModPortVif=NULL;
   p_vpi_value comp_name_p=NULL;
   char *vifDeclFull=NULL, *vifFileLineNo=NULL, *ifFileLineNo=NULL, *objIdStr=NULL, *objOrgIdStr=NULL, *vifDefName=NULL;
   int event_handle;
   bool isModPort=FALSE;
   vpiHandle ch_itr_arr[2];
   int ch_itr_arr_num = 1; 

   if(hClassDefn && strcmp(vpi_get_str(vpiName, hClassDefn),"uvm_dhier_component")==0) {
      return; // for those classObj cannot find classDefn, check below
   }

   hName = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "m_name", hClassObj);
   if(!hName && hClassObj)
      hName = retrieve_component_name_handle(hClassObj, (char*) "m_name");

   if(hName) { 
      comp_name_p = (p_vpi_value) malloc(sizeof(s_vpi_value));
      comp_name_p->format = vpiObjTypeVal;
      vpi_get_value(hName, comp_name_p);
   }   

   if(comp_name_p && strcmp(comp_name_p->value.str, "DHIER_COMP")==0) 
      return;

#ifdef VCS
   char objId[10];
#endif

   char *prtObjIdStr=NULL, *objClass=NULL, *portClass=NULL, *objLibrary=NULL, *portLibrary=NULL;

   if(hClassObj!=NULL) {

      if(is_port_component(hClassDefn)) {
         prtObjIdStr = retrieve_port_objid(hClassObj, &portClass, &portLibrary);
      } 

      if(hClassDefn) {
         objClass    = retrieve_simple_class_by_classdefn(hClassDefn, &objLibrary, &objOrgIdStr); 
      } else {

         objOrgIdStr = reformat_protected_scope_name(vpi_get_str(vpiScope, hClassObj));

         if(objOrgIdStr)
            objClass = remove_class_backslash_parameters(objOrgIdStr);

      }

#ifdef VCS
      if(objOrgIdStr) {
         sprintf(objId, "@%ld", (long int)vpi_get(vpiId, hClassObj));
         objOrgIdStr = concat_strings(objOrgIdStr, objId);
      } 
#endif

      if(objOrgIdStr && comp_name_p) {
         event_handle =  pli_dhier_begin_event((char*) "COMP_OBJID");
         pli_dhier_set_label(event_handle, comp_name_p->value.str);
         pli_dhier_add_attribute(event_handle, (char*) "component_objId", objOrgIdStr);

         if(objLibrary) 
            pli_dhier_add_attribute(event_handle, (char*) "component_library", objLibrary);

         if(objClass) 
            pli_dhier_add_attribute(event_handle, (char*) "component_class", objClass);

         if(prtObjIdStr) {
            pli_dhier_add_attribute(event_handle, (char*) "port_objId", prtObjIdStr);
            free(prtObjIdStr);
         }

         if(portLibrary) {
            pli_dhier_add_attribute(event_handle, (char*) "port_library", portLibrary);
            free(portLibrary);
         }
         if(portClass) {
            pli_dhier_add_attribute(event_handle, (char*) "port_class", portClass);
            free(portClass); 
         }
         pli_dhier_end_event(event_handle);

      } else {
         return;
      }
   } else {
      return;
   }

   ch_itr_arr[0] = NULL;
   ch_itr_arr[1] = NULL; 

#ifdef VCS
   ch_itr_arr[0] = vpi_iterate(vpiVirtualInterfaceVar, hClassObj);
#endif

   if(!ch_itr_arr[0]){
      hChildren = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "common", hClassObj);
      if (hChildren){
          ch_itr_arr[0] = vpi_iterate(vpiVirtualInterfaceVar, hChildren);
          if(!ch_itr_arr[0]){
             ch_itr_arr[0] = vpi_iterate(vpiVariables, hClassObj);
          }
      }else{
          hChildren = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "cfg", hClassObj);
          if (hChildren){
              ch_itr_arr[0] = vpi_iterate(vpiVirtualInterfaceVar, hChildren);
              if(!ch_itr_arr[0]){
                 ch_itr_arr[0] = vpi_iterate(vpiVariables, hClassObj);
              }
          } else {
              ch_itr_arr[0] = vpi_iterate(vpiVariables, hClassObj);
          }
      }
   }else{
      hChildren = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "cfg", hClassObj);
      if (hChildren){
          ch_itr_arr[1] = vpi_iterate(vpiVirtualInterfaceVar, hChildren);
          if(!ch_itr_arr[1]){
             ch_itr_arr[1] = vpi_iterate(vpiVariables, hClassObj);
          }
      } else {
          hChildren = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "common", hClassObj);
          if (hChildren){
              ch_itr_arr[1] = vpi_iterate(vpiVirtualInterfaceVar, hChildren);
              if(!ch_itr_arr[1]){
                 ch_itr_arr[1] = vpi_iterate(vpiVariables, hClassObj);
              }    
          } else {
              ch_itr_arr[1] = vpi_iterate(vpiVariables, hClassObj);
          } 
      }       
   }

   if (ch_itr_arr[1]!=NULL)
       ch_itr_arr_num = 2;

   for (int i=0;i<ch_itr_arr_num;i++){
        hChIter = ch_itr_arr[i];    
   while(( hVif = vpi_scan(hChIter))) {
      if(vpi_get(vpiType, hVif) != vpiVirtualInterfaceVar &&
         vpi_get(vpiType, hVif) != vpiRefObj){
         vpi_release_handle(hVif); 
         continue;
      }

      hVifActual = vpi_handle(vpiActual, hVif);

      if(hVifActual==NULL){ 
         vpi_release_handle(hVif); 
         continue;
      } 

      char *_file;

      _file = vpi_get_str(vpiFile, hVif);
      vifFileLineNo = (char*) malloc((strlen(_file) + 1024) *sizeof(char));
      sprintf(vifFileLineNo, "%s(%d)", _file, vpi_get(vpiLineNo, hVif));

      _file = vpi_get_str(vpiFile, hVifActual);
      ifFileLineNo = (char*) malloc((strlen(_file) + 1024) * sizeof(char));
      sprintf(ifFileLineNo, "%s(%d)", _file, vpi_get(vpiLineNo, hVifActual)); 

      if(objClass) {
         char *_tmp_str;
         _tmp_str = vpi_get_str(vpiName, hVif);
         vifDeclFull = (char*) malloc((strlen(objClass) + strlen(_tmp_str) + 2) * sizeof(char));
         sprintf(vifDeclFull, "%s.%s", objClass, _tmp_str); 
   }

#ifdef VCS     
      if(objOrgIdStr) { 
         char *_tmp_str;
         _tmp_str = vpi_get_str(vpiName, hVif);
         objIdStr = (char*) malloc((strlen(objOrgIdStr) + strlen(_tmp_str) + 2) * sizeof(char));
         sprintf(objIdStr, "%s.%s", objOrgIdStr, _tmp_str);
      }
#endif

#ifdef INCA
      objIdStr = concat_strings(objIdStr, vpi_get_str(vpiName, hClassObj));
#endif

      event_handle =  pli_dhier_begin_event((char*) "VIF");
      pli_dhier_set_label(event_handle, comp_name_p->value.str);

      pli_dhier_add_attribute(event_handle, (char*) "component_name", comp_name_p->value.str);

      pli_dhier_add_attribute(event_handle, (char*) "component_class_name", vpi_get_str(vpiFullName, hClassDefn));

      if(objIdStr)
         pli_dhier_add_attribute(event_handle, (char*) "vif_objId", objIdStr);

      if(objLibrary)
         pli_dhier_add_attribute(event_handle, (char*) "virtual_interface_library", objLibrary);

      pli_dhier_add_attribute(event_handle, (char*) "virtual_interface_declaration", vifDeclFull);
      pli_dhier_add_attribute(event_handle, (char*) "vif_declaration_filelineno", vifFileLineNo);

      PLI_INT32 vif_type;
      vif_type = vpi_get(vpiType, hVifActual);

      isModPort = (vif_type == vpiModport) ? TRUE : FALSE;
   
      hModPortVif = isModPort ? vpi_handle(vpiInterface, hVifActual) : NULL;

      char *_modport_def_name_str=NULL, *_vifactual_defname=NULL;

      _vifactual_defname = vpi_get_str(vpiDefName, hVifActual);

      if(hModPortVif) {
         _modport_def_name_str = vpi_get_str(vpiDefName, hModPortVif);
      }

      if(_modport_def_name_str)
         vifDefName = (char*) malloc((strlen(_modport_def_name_str) + strlen(_vifactual_defname) + 2) * sizeof(char));
      else
         vifDefName = (char*) malloc((strlen(_vifactual_defname) + 1) * sizeof(char));

      if(_modport_def_name_str)
         sprintf(vifDefName, "%s.%s", _modport_def_name_str, _vifactual_defname);
      else
         sprintf(vifDefName, "%s", _vifactual_defname);


      pli_dhier_add_attribute(event_handle, (char*) "interface_definition", vifDefName);
      pli_dhier_add_attribute(event_handle, (char*) "interface_declaration_filelineno", ifFileLineNo);
      pli_dhier_add_attribute(event_handle, (char*) "interface_path", vpi_get_str(vpiFullName, hVifActual));
      pli_dhier_end_event(event_handle);
      
      if(vifDeclFull) {
         free(vifDeclFull); 
         vifDeclFull = NULL;
      }

      if(vifFileLineNo) {
         free(vifFileLineNo);
         vifFileLineNo = NULL;
      }

      if(ifFileLineNo) {
         free(ifFileLineNo);
         ifFileLineNo = NULL;
      }

      if(objIdStr) {
         free(objIdStr);
         objIdStr = NULL;
      }

      if(vifDefName) {
         free(vifDefName);
         vifDefName = NULL;
      }

      if(hVif)
         vpi_release_handle(hVif);
      if(hVifActual)
         vpi_release_handle(hVifActual);
      if(hModPortVif)
         vpi_release_handle(hModPortVif);
 
   }  // end of : while(( hVif = vpi_scan(hChIter)))
   }  // end of : for (int i=0;i<ch_itr_arr_num;i++)
   
   if(comp_name_p)
      free((void *)comp_name_p);
   if(objClass)
      free(objClass);
   if(objOrgIdStr)
      free(objOrgIdStr);
   if(objLibrary)
      free(objLibrary);

   if(hChildren)
      vpi_release_handle(hChildren);
   if(hName)
      vpi_release_handle(hName);
   
   return;
}

void traverse_comp_from_base_classdefn(vpiHandle hClassDefn) {
   vpiHandle hIterDerivedClass=NULL, hDerivedClassDefn=NULL;
   vpiHandle hIterLiveObj=NULL, hLiveObj=NULL;

   if(!hClassDefn) return;
   if(vpi_get(vpiType, hClassDefn)!=vpiClassDefn) return;

   if(strcmp(vpi_get_str(vpiName, hClassDefn),"uvm_dhier_component")==0 || strcmp(vpi_get_str(vpiName, hClassDefn), "uvm_root")==0 ) {
      return;
   }

   // Recursive to find all derived class 
   hIterDerivedClass = vpi_iterate(vpiDerivedClasses, hClassDefn);
   while( (hDerivedClassDefn = vpi_scan(hIterDerivedClass)) != NULL) {   
      traverse_comp_from_base_classdefn(hDerivedClassDefn);
      vpi_release_handle(hDerivedClassDefn); 
   }

   hIterLiveObj = vpi_iterate(vpiLiveObjects, hClassDefn);
   while( (hLiveObj = vpi_scan(hIterLiveObj)) != NULL) {
      retrieve_comp_intf(hLiveObj, hClassDefn);
      vpi_release_handle(hLiveObj); 
   }

   return;
}

void traverse_comp_from_hierarchy(vpiHandle hParent) {
   vpiHandle hChildren=NULL, hChild=NULL, hChItr=NULL;
   vpiHandle hClassObj=NULL, hClassDefn=NULL;

   if(!hParent)
	   return;

   hChildren = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "m_children_by_handle", hParent);

   if(!hChildren && hParent)
      hChildren = retrieve_component_name_handle(hParent, (char*) "m_children_by_handle");

   if(hChildren!=NULL) {
      hChItr = vpi_iterate(vpiReg, hChildren);
   }
  
   while(hChItr && (hChild = vpi_scan(hChItr)) )  {
     traverse_comp_from_hierarchy(hChild);
     vpi_release_handle(hChild); 
   }

   if(vpi_get(vpiType, hParent)!=vpiClassObj) 
      hClassObj = vpi_handle(vpiClassObj, hParent);
   else
      hClassObj = hParent;

   if(hClassObj)
	   hClassDefn = vpi_handle(vpiClassDefn, hClassObj);

   retrieve_comp_intf(hClassObj, hClassDefn); // hClassDefn can be NULL
   
   if(hChildren)
      vpi_release_handle(hChildren);
   
   if( hClassObj && vpi_compare_objects(hClassObj, hParent)!=1 )
      vpi_release_handle(hClassObj);

   if(hClassDefn)
      vpi_release_handle(hClassDefn);

   return;
}


/* 
   1. Original function name: retrieve_comp_intf(vpiHandle parent)
   2. Spilt the original function to 2 parts: 
     (i)  Get uvm components.
          --> (old flow) : traverse_comp_from_hierarchy(vpiHandle hParent)
          --> (new flow) : traverse_comp_from_base_classdefn(vpiHandle hClassDefn)
     (ii) Retrive data from uvm component then dump to FSDB.
          --> retrieve_comp_intf(vpiHandle hClassObj, vpiHandle hClassDefn)
   3. Rename and keep this function. Can remove it when new flow become stable.
*/ 
void traverse_hier_and_retrieve_comp_intf(vpiHandle parent) {

   vpiHandle children=NULL, child=NULL, ch_itr=NULL, obj=NULL, objDefn=NULL, name_handle=NULL, vif=NULL, vifActual=NULL, modport_vif=NULL;
   p_vpi_value comp_name_p=NULL;
   char *vifDeclFull=NULL, *vifFileLineNo=NULL, *ifFileLineNo=NULL, *objIdStr=NULL, *objOrgIdStr=NULL, *vifDefName=NULL;
   int eHandle;
   bool isModPort=FALSE;
   vpiHandle ch_itr_arr[2];
   int ch_itr_arr_num = 1; 

   children = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "m_children_by_handle", parent);

   if(!children && parent)
      children = retrieve_component_name_handle(parent, (char*) "m_children_by_handle");

   if(children!=NULL) {
      ch_itr = vpi_iterate(vpiReg, children);
   }
  
   while(ch_itr && (child = vpi_scan(ch_itr)) )  {
     traverse_hier_and_retrieve_comp_intf(child);
   }

   name_handle = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "m_name", parent);

   if(!name_handle && parent)
      name_handle = retrieve_component_name_handle(parent, (char*) "m_name");

   if(name_handle) { 
      comp_name_p = (p_vpi_value) malloc(sizeof(s_vpi_value));
      comp_name_p->format = vpiObjTypeVal;
      vpi_get_value(name_handle, comp_name_p);
   }

#ifdef VCS
   char objId[10];
#endif

   char *prtObjIdStr=NULL, *objClass=NULL, *portClass=NULL, *objLibrary=NULL, *portLibrary=NULL;

   if(vpi_get(vpiType, parent)!=vpiClassObj) 
      obj = vpi_handle(vpiClassObj, parent);
   else
      obj = parent;

   if(obj) {

      objDefn = vpi_handle(vpiClassDefn, obj);

      if(is_port_component(objDefn)) {
         prtObjIdStr = retrieve_port_objid(obj, &portClass, &portLibrary);
      } 

      if(objDefn) {
         objClass    = retrieve_simple_class_by_classdefn(objDefn, &objLibrary, &objOrgIdStr); 
      } else {

         objOrgIdStr = reformat_protected_scope_name(vpi_get_str(vpiScope, obj));

         if(objOrgIdStr)
            objClass    = remove_class_backslash_parameters(objOrgIdStr);

      }

#ifdef VCS
      if(objOrgIdStr) {
         sprintf(objId, "@%ld", (long int)vpi_get(vpiId, obj));
         objOrgIdStr = concat_strings(objOrgIdStr, objId);
      } 
#endif
      
      if(objOrgIdStr && comp_name_p && strcmp(comp_name_p->value.str, "DHIER_COMP")!=0 ) {
         eHandle =  pli_dhier_begin_event((char*) "COMP_OBJID");
         pli_dhier_set_label(eHandle, comp_name_p->value.str);
         pli_dhier_add_attribute(eHandle, (char*) "component_objId", objOrgIdStr);

         if(objLibrary) 
            pli_dhier_add_attribute(eHandle, (char*) "component_library", objLibrary);

         if(objClass) 
            pli_dhier_add_attribute(eHandle, (char*) "component_class", objClass);

         if(prtObjIdStr) {
            pli_dhier_add_attribute(eHandle, (char*) "port_objId", prtObjIdStr);
            free(prtObjIdStr);
         }

         if(portLibrary) {
            pli_dhier_add_attribute(eHandle, (char*) "port_library", portLibrary);
            free(portLibrary);
         }
         if(portClass) {
            pli_dhier_add_attribute(eHandle, (char*) "port_class", portClass);
            free(portClass); 
         }
         pli_dhier_end_event(eHandle);
      } else {
         return;
      }
   } else {
      return;
   }

   ch_itr_arr[0] = NULL;
   ch_itr_arr[1] = NULL; 

#ifdef VCS
   ch_itr_arr[0] = vpi_iterate(vpiVirtualInterfaceVar, obj);
#endif

   if(!ch_itr_arr[0]){
      children = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "common", obj);
      if (children){
          ch_itr_arr[0] = vpi_iterate(vpiVirtualInterfaceVar, children);
          if(!ch_itr_arr[0]){
             ch_itr_arr[0] = vpi_iterate(vpiVariables, obj);
          }
      }else{
          children = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "cfg", obj);
          if (children){
              ch_itr_arr[0] = vpi_iterate(vpiVirtualInterfaceVar, children);
              if(!ch_itr_arr[0]){
                 ch_itr_arr[0] = vpi_iterate(vpiVariables, obj);
              }
          } else {
              ch_itr_arr[0] = vpi_iterate(vpiVariables, obj);
          }
      }
   }else{
      children = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "cfg", obj);
      if (children){
          ch_itr_arr[1] = vpi_iterate(vpiVirtualInterfaceVar, children);
          if(!ch_itr_arr[1]){
             ch_itr_arr[1] = vpi_iterate(vpiVariables, obj);
          }
      } else {
          children = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) "common", obj);
          if (children){
              ch_itr_arr[1] = vpi_iterate(vpiVirtualInterfaceVar, children);
              if(!ch_itr_arr[1]){
                 ch_itr_arr[1] = vpi_iterate(vpiVariables, obj);
              }    
          } else {
              ch_itr_arr[1] = vpi_iterate(vpiVariables, obj);
          } 
      }       
   }

   if (ch_itr_arr[1]!=NULL)
       ch_itr_arr_num = 2;

   for (int i=0;i<ch_itr_arr_num;i++){
        ch_itr = ch_itr_arr[i];    
   while(( vif = vpi_scan(ch_itr))) {
      if(vpi_get(vpiType, vif) != vpiVirtualInterfaceVar &&
         vpi_get(vpiType, vif) != vpiRefObj){
         continue;
      }

      vifActual = vpi_handle(vpiActual, vif);

      if(vifActual==NULL){ 
         continue;
      } 

      char *_file;

      _file = vpi_get_str(vpiFile, vif);
      vifFileLineNo = (char*) malloc((strlen(_file) + 1024) *sizeof(char));
      sprintf(vifFileLineNo, "%s(%d)", _file, vpi_get(vpiLineNo, vif));

      _file = vpi_get_str(vpiFile, vifActual);
      ifFileLineNo = (char*) malloc((strlen(_file) + 1024) * sizeof(char));
      sprintf(ifFileLineNo, "%s(%d)", _file, vpi_get(vpiLineNo, vifActual)); 

      if(objClass) {
         char *_tmp_str;
         _tmp_str = vpi_get_str(vpiName, vif);
         vifDeclFull = (char*) malloc((strlen(objClass) + strlen(_tmp_str) + 2) * sizeof(char));
         sprintf(vifDeclFull, "%s.%s", objClass, _tmp_str); 
      }

#ifdef VCS
     
      if(objOrgIdStr) { 
         char *_tmp_str;
         _tmp_str = vpi_get_str(vpiName, vif);
         objIdStr = (char*) malloc((strlen(objOrgIdStr) + strlen(_tmp_str) + 2) * sizeof(char));
         sprintf(objIdStr, "%s.%s", objOrgIdStr, _tmp_str);
      }
#endif

#ifdef INCA

      objIdStr = concat_strings(objIdStr, vpi_get_str(vpiName, obj));

#endif

      eHandle =  pli_dhier_begin_event((char*) "VIF");
      pli_dhier_set_label(eHandle, comp_name_p->value.str);

      pli_dhier_add_attribute(eHandle, (char*) "component_name", comp_name_p->value.str);

      pli_dhier_add_attribute(eHandle, (char*) "component_class_name", vpi_get_str(vpiFullName, objDefn));

      if(objIdStr)
         pli_dhier_add_attribute(eHandle, (char*) "vif_objId", objIdStr);

      if(objLibrary)
         pli_dhier_add_attribute(eHandle, (char*) "virtual_interface_library", objLibrary);

      pli_dhier_add_attribute(eHandle, (char*) "virtual_interface_declaration", vifDeclFull);
      pli_dhier_add_attribute(eHandle, (char*) "vif_declaration_filelineno", vifFileLineNo);

      PLI_INT32 vif_type;
      vif_type = vpi_get(vpiType, vifActual);

      isModPort = (vif_type == vpiModport) ? TRUE : FALSE;
   
      modport_vif = isModPort ? vpi_handle(vpiInterface, vifActual) : NULL;

      char *_modport_def_name_str=NULL, *_vifactual_defname=NULL;

      _vifactual_defname = vpi_get_str(vpiDefName, vifActual);

      if(modport_vif) {
         _modport_def_name_str = vpi_get_str(vpiDefName, modport_vif);
      }

      if(_modport_def_name_str)
         vifDefName = (char*) malloc((strlen(_modport_def_name_str) + strlen(_vifactual_defname) + 2) * sizeof(char));
       else
         vifDefName = (char*) malloc((strlen(_vifactual_defname) + 1) * sizeof(char));

      if(_modport_def_name_str)
         sprintf(vifDefName, "%s.%s", _modport_def_name_str, _vifactual_defname);
      else
         sprintf(vifDefName, "%s", _vifactual_defname);


      pli_dhier_add_attribute(eHandle, (char*) "interface_definition", vifDefName);
      pli_dhier_add_attribute(eHandle, (char*) "interface_declaration_filelineno", ifFileLineNo);
      pli_dhier_add_attribute(eHandle, (char*) "interface_path", vpi_get_str(vpiFullName, vifActual));
     
      pli_dhier_end_event(eHandle);

      if(vifDeclFull) {
         free(vifDeclFull); 
         vifDeclFull = NULL;
      }

      if(vifFileLineNo) {
         free(vifFileLineNo);
         vifFileLineNo = NULL;
      }

      if(ifFileLineNo) {
         free(ifFileLineNo);
         ifFileLineNo = NULL;
      }

      if(objIdStr) {
         free(objIdStr);
         objIdStr = NULL;
      }

      if(vifDefName) {
         free(vifDefName);
         vifDefName = NULL;
      }
 
   }
   }
   if(comp_name_p)
      free((void *)comp_name_p);
   if(objClass)
      free(objClass);
   if(objOrgIdStr)
      free(objOrgIdStr);
   if(objLibrary)
      free(objLibrary);
   
}

void verdi_dhier_interface_by_comp_hier(char *rsrc) {

   vpiHandle hFrame=NULL, scope=NULL, classObj=NULL;

   hFrame = vpi_handle(vpiFrame, 0);

   if(hFrame)
     scope  = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) rsrc, hFrame);

   if(scope && vpi_get(vpiType, scope)!=vpiClassObj)
      classObj = vpi_handle(vpiClassObj, scope); 

   if(classObj)
      traverse_comp_from_hierarchy(classObj);

   if(hFrame)
      vpi_release_handle(hFrame);
   if(scope)
      vpi_release_handle(scope);
   if(classObj)
      vpi_release_handle(classObj);

   return;
}

void verdi_dhier_interface_by_classdefn(char* rsrc) {
   vpiHandle hFrame=NULL, hScope=NULL, hClassObj=NULL, hClassDefn=NULL, hBaseClassDefn=NULL;

   hFrame = vpi_handle(vpiFrame, 0);
   if(hFrame)
     hScope  = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) rsrc, hFrame);

   if(hScope && vpi_get(vpiType, hScope)!=vpiClassDefn)
      hClassObj = vpi_handle(vpiClassObj, hScope); 

   if(hClassObj && strcmp(vpi_get_str(vpiName, hClassObj), "uvm_dhier_component")==0 ) {
      hClassDefn = vpi_handle(vpiClassDefn, hClassObj);
      hBaseClassDefn = vpi_handle(vpiExtends, hClassDefn);
   }

   if(hBaseClassDefn && strcmp(vpi_get_str(vpiName, hBaseClassDefn), "uvm_component")==0) {
      traverse_comp_from_base_classdefn(hBaseClassDefn);
   }

   if(hFrame)
      vpi_release_handle(hFrame);
   if(hScope)
      vpi_release_handle(hScope);
   if(hClassObj)
      vpi_release_handle(hClassObj);
   if(hClassDefn)
      vpi_release_handle(hClassDefn);
   if(hBaseClassDefn)
      vpi_release_handle(hBaseClassDefn);
}


char* retrieve_def_class(const char *var_name, int& objid) {
   
   vpiHandle _hFrame=NULL, _varH=NULL, _var_class_obj=NULL, _var_class_defn=NULL;

   _hFrame       = vpi_handle(vpiFrame, 0);

   _varH = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) var_name, _hFrame);
   vpi_release_handle(_hFrame);
   
   if(_varH==NULL) 
      return NULL;

   if(vpi_get(vpiType, _varH)!=vpiClassObj) { 
      _var_class_obj = vpi_handle(vpiClassObj, _varH);
	  vpi_release_handle(_varH); 
   }else {
      _var_class_obj = _varH;
   }
   
   if(!_var_class_obj) 
      return NULL;
   

   _var_class_defn = vpi_handle(vpiClassDefn, _var_class_obj);

   if(_var_class_defn==NULL) {
      vpi_release_handle(_var_class_obj); 
      return NULL;
   }

#ifdef VCS
   objid = vpi_get(vpiId, _var_class_obj); 
#else
   objid = 0;
#endif

   char* result_str = (char*) vpi_get_str(vpiFullName, _var_class_defn);
   vpi_release_handle(_var_class_defn); 
   vpi_release_handle(_var_class_obj);
   return result_str;
}

void retrieve_reg_def_class(char* var_name, int _handle, int is_objid_only) {

   vpiHandle _hFrame=NULL, _varH=NULL, _var_class_obj=NULL, _var_class_defn=NULL,  _var_package=NULL;
   vpiHandle _origin_frame=NULL;
   char *_var_pkg_name=NULL, *_var_pkg_class_name=NULL, *_class_str=NULL;
   int _size=0, _class_str_size=0;;

   _hFrame       = vpi_handle(vpiFrame, 0);
   _origin_frame = vpi_handle(vpiParent, _hFrame);

   _varH = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) var_name, _origin_frame);

   if(!_varH) {
      if(_hFrame)
         vpi_release_handle(_hFrame);
      if(_origin_frame)
         vpi_release_handle(_origin_frame);
      return;
   }

   if(vpi_get(vpiType, _varH)==vpiClassVar)
      _var_class_obj = vpi_handle(vpiClassObj, _varH);
   else if(vpi_get(vpiType, _varH)==vpiClassObj)
      _var_class_obj = _varH;

   if(!_var_class_obj) {
      if(_hFrame)
         vpi_release_handle(_hFrame);
      if(_origin_frame)
         vpi_release_handle(_origin_frame);
      if(_varH)
         vpi_release_handle(_varH); 
      return;
   }


   _var_class_defn = vpi_handle(vpiClassDefn, _var_class_obj);

   if(!_var_class_defn) {
      if(_hFrame)
         vpi_release_handle(_hFrame);
      if(_origin_frame)
         vpi_release_handle(_origin_frame);
      if(_varH)
         vpi_release_handle(_varH); 
      if(_var_class_obj)
         vpi_release_handle(_var_class_obj);
      return;
   }

#ifdef VCS
   char  *_rtn_str=NULL;

   _class_str = vpi_get_str(vpiFullName, _var_class_defn);

   if(_class_str!=NULL) {

      _class_str_size = strlen(_class_str);
 
      _rtn_str = (char *) malloc((_class_str_size + 024) * sizeof(char));

      sprintf(_rtn_str, "\\%s @%ld", _class_str, (long int)vpi_get(vpiId, _var_class_obj));

      if(_rtn_str) {
         pli_dhier_add_attribute(_handle, "snps_object_id", _rtn_str);
         free(_rtn_str);
         _rtn_str = NULL;
      }  

   }

   if(is_objid_only) {
	  if(_hFrame)
         vpi_release_handle(_hFrame);
      if(_origin_frame)
         vpi_release_handle(_origin_frame);
      if(_varH)
         vpi_release_handle(_varH); 
      if(_var_class_obj)
         vpi_release_handle(_var_class_obj);
	  if(_var_class_defn)
		 vpi_release_handle(_var_class_defn);
      return;
   }

#endif

   _var_package = vpi_handle(vpiScope, _var_class_defn);

   if(_var_package) 
      _var_pkg_name = vpi_get_str(vpiDefName, _var_package);

   _class_str = vpi_get_str(vpiName, _var_class_defn);

   _class_str_size = strlen(_class_str);

   if(_var_pkg_name!=NULL) 
      _size = strlen(_var_pkg_name) + _class_str_size + 1;
   else 
      _size = _class_str_size;

   _var_pkg_class_name = (char*) malloc(sizeof(char) * (_size + 1));

   if(_var_pkg_name!=NULL) 
      sprintf(_var_pkg_class_name, "%s.%s", _var_pkg_name, _class_str);
   else
      sprintf(_var_pkg_class_name, "%s", _class_str);

   pli_dhier_add_attribute(_handle, (char*) "class_name", _var_pkg_class_name);

   free(_var_pkg_class_name);
   
   if(_hFrame)
	  vpi_release_handle(_hFrame);
   if(_origin_frame)
	  vpi_release_handle(_origin_frame);
   if(_varH)
	  vpi_release_handle(_varH); 
   if(_var_class_obj)
	  vpi_release_handle(_var_class_obj);
   if(_var_class_defn)
	  vpi_release_handle(_var_class_defn);
   if(_var_package)
	  vpi_release_handle(_var_package);

   return;
}

bool is_match_obj(unsigned int _var_id, const char* _var_scope_id_str, vpiHandle _matchee) {
   char *_matchee_scope_id_str=NULL;

   if(_matchee == NULL)
      return FALSE;

#ifdef VCS
   if(_var_id!=0 && _var_id == (unsigned int)vpi_get(vpiId, _matchee))
      return TRUE;
#endif

   if(_var_id==0 && _var_scope_id_str!=NULL) {

      _matchee_scope_id_str = concat_strings(_matchee_scope_id_str, vpi_get_str(vpiFullName, _matchee));

      if(!_matchee_scope_id_str)
         return FALSE;

      if(!strcmp(_var_scope_id_str, _matchee_scope_id_str)) {
         free(_matchee_scope_id_str);
         return TRUE;
      }
   }

   if(_matchee_scope_id_str)
      free(_matchee_scope_id_str);
 
   return FALSE;
}

int record_reg_decl_name(int handle, char* parent_var_name, char* var_name, char* obj_name) {

   vpiHandle _h_frame=NULL, _h_origin_frame=NULL;
   vpiHandle _h_parent_var=NULL, _h_var=NULL, _h_ary_var=NULL;
   vpiHandle _h_parent_class_obj=NULL, _h_var_class_obj=NULL, _h_var_class_defn=NULL;
   vpiHandle _h_itr=NULL, _h_ary_itr=NULL;
   unsigned int _var_id=0;
   char *_var_class_name=NULL, *_cur_var_class_name=NULL, *_var_scope_id_str=NULL;
   char *_decl_name_from_ary=NULL;
   char *_var_def_file=NULL;
   int _var_def_file_lineno;

   _h_frame = vpi_handle(vpiFrame, 0);
 
   _h_parent_var = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) parent_var_name, _h_frame);
 
   if(vpi_get(vpiType, _h_parent_var) == vpiClassVar) {
      _h_parent_class_obj = vpi_handle(vpiClassObj, _h_parent_var);
   } else if(vpi_get(vpiType, _h_parent_var) == vpiClassObj) {
      _h_parent_class_obj = _h_parent_var;
   } else {
	  
	  if(_h_frame)
		  vpi_release_handle(_h_frame);
	  if(_h_parent_var)
		  vpi_release_handle(_h_parent_var);
      return 0;
   }

   char *_simple_array_name=NULL;

   _simple_array_name = retrieve_simple_array_name(obj_name);

   if(_simple_array_name!=NULL) {
      _h_var = VERDI_UVM_VPI_HANDLE_BY_NAME(_simple_array_name, _h_parent_class_obj);
      free(_simple_array_name);
      _simple_array_name = NULL;
   }

   if(_h_var==NULL)
      _h_var = VERDI_UVM_VPI_HANDLE_BY_NAME(obj_name, _h_parent_class_obj);

   if(_h_var) {

      char* _decl_name=NULL, *_filename_lineno=NULL;

      _var_def_file        = vpi_get_str(vpiFile, _h_var);
      _var_def_file_lineno = vpi_get(vpiLineNo, _h_var);

      if(vpi_get(vpiArrayMember, _h_var)) {
         vpiHandle _h_var_parent=NULL, _h_cur_var=NULL;

         _h_cur_var = _h_var;
         _h_var = NULL;

         _h_var_parent = vpi_handle(vpiParent, _h_cur_var);
         while(_h_var_parent && vpi_get(vpiArrayMember, _h_var_parent)) {
            vpi_release_handle (_h_cur_var);
            _h_cur_var = _h_var_parent;
            _h_var_parent = vpi_handle(vpiParent, _h_cur_var);
         }

         if(_h_var_parent) {
            _h_var = _h_var_parent;
            vpi_release_handle(_h_cur_var);
         } else if(_h_cur_var) {
            _h_var = _h_cur_var;
         }

      }

      if(_h_var)
         _decl_name = vpi_get_str(vpiName, _h_var);

      pli_dhier_add_attribute(handle, "declaration_name", _decl_name);

      _filename_lineno = (char*) malloc((strlen(_var_def_file) + 1024) * sizeof(char));
      sprintf(_filename_lineno, "%s(%d)", _var_def_file, _var_def_file_lineno);
      pli_dhier_add_attribute(handle, "declaration_name_filename_lineno", _filename_lineno);

      if(_filename_lineno)
         free(_filename_lineno);

      if(_h_frame)
		  vpi_release_handle(_h_frame);
	  if(_h_parent_class_obj)
		  vpi_release_handle(_h_parent_class_obj);
	  if(_h_var)
		  vpi_release_handle(_h_var);
	  
      return 1;
   }

   _h_origin_frame = vpi_handle(vpiParent, _h_frame);
   _h_var = VERDI_UVM_VPI_HANDLE_BY_NAME((PLI_BYTE8*) var_name, _h_origin_frame);

   if(vpi_get(vpiType, _h_var) == vpiClassVar) {
      _h_var_class_obj = vpi_handle(vpiClassObj, _h_var);
   } else if(vpi_get(vpiType, _h_var) == vpiClassObj) {
      _h_var_class_obj = _h_var;
   } else {
      if(_h_frame)
         vpi_release_handle(_h_frame);
      if(_h_origin_frame)
         vpi_release_handle(_h_origin_frame);
      if(_h_var)
         vpi_release_handle(_h_var);
	  if(_h_parent_class_obj && vpi_compare_objects(_h_parent_class_obj, _h_parent_var)!=1)
		  vpi_release_handle(_h_parent_class_obj);
      if(_h_parent_var)
         vpi_release_handle(_h_parent_var);
      return 0;
   }

   _h_itr = vpi_iterate(vpiVariables, _h_parent_class_obj); 

#ifdef VCS
   _var_id = vpi_get(vpiId, _h_var_class_obj);
#endif

   if(_var_id==0) 
      _var_scope_id_str = concat_strings(_var_scope_id_str, vpi_get_str(vpiFullName, _h_var_class_obj)); 

   _h_var_class_defn = vpi_handle(vpiClassDefn, _h_var_class_obj);

   if(_h_var_class_defn)
      _var_class_name = concat_strings(_var_class_name, vpi_get_str(vpiName, _h_var_class_defn));

   if(_h_var)
      vpi_release_handle(_h_var);
   if(_h_var_class_obj)
      vpi_release_handle(_h_var_class_obj);
   if(_h_var_class_defn)
      vpi_release_handle(_h_var_class_defn);

   while((_h_var = vpi_scan(_h_itr)) && _var_class_name!=NULL) {

      if(vpi_get(vpiType, _h_var) == vpiClassVar) {

         _h_var_class_obj = vpi_handle(vpiClassObj, _h_var);
         
      } else if(vpi_get(vpiType, _h_var) == vpiClassObj) {

         _h_var_class_obj = _h_var;

      } else if(vpi_get(vpiType, _h_var) == vpiArrayVar) {

         if(_decl_name_from_ary) {
            vpi_release_handle(_h_var);
            continue;
         }

         if(_cur_var_class_name) {
            free(_cur_var_class_name);
            _cur_var_class_name = NULL;
         }

         _h_ary_itr = vpi_iterate(vpiReg, _h_var);

         // Improvement ?? light-weight hash??
         while((_h_ary_var = vpi_scan(_h_ary_itr))) {

            if(vpi_get(vpiType, _h_ary_var)== vpiClassVar ) {

               _h_var_class_obj = vpi_handle(vpiClassObj, _h_ary_var);
            } else if(vpi_get(vpiType, _h_ary_var) == vpiClassObj) 
               _h_var_class_obj = _h_ary_var;
            else {
               vpi_release_handle(_h_ary_var);
               continue;
            }

            if(_cur_var_class_name==NULL)
               _cur_var_class_name = concat_strings(_cur_var_class_name, vpi_get_str(vpiName, vpi_handle(vpiClassDefn, _h_var_class_obj)));

            if(!_cur_var_class_name) {
               vpi_release_handle(_h_ary_var);
               if(_h_var_class_obj)
                  vpi_release_handle(_h_var_class_obj);
               continue;
            }

            if(_cur_var_class_name && strcmp(_var_class_name, _cur_var_class_name)) {
               vpi_release_handle(_h_ary_var);
               if(_h_var_class_obj)
                  vpi_release_handle(_h_var_class_obj);
               continue; 
            }

            if(!is_match_obj(_var_id, _var_scope_id_str, _h_var_class_obj))  {
               _h_var_class_obj = NULL;
               vpi_release_handle(_h_ary_var);
               if(_h_var_class_obj)
                  vpi_release_handle(_h_var_class_obj);
               continue;
            }

            _decl_name_from_ary = vpi_get_str(vpiName, _h_var); 
            _var_def_file = vpi_get_str(vpiFile, _h_var);
            _var_def_file_lineno = vpi_get(vpiLineNo, _h_var);

            vpi_release_handle(_h_ary_var);
            if(_h_var_class_obj)
               vpi_release_handle(_h_var_class_obj);
            break;
         }

         vpi_release_handle(_h_var);
         continue;

      } else {
         vpi_release_handle(_h_var);
         continue;
      }

      if(!is_match_obj(_var_id, _var_scope_id_str, _h_var_class_obj)) {

         if(_h_var != _h_var_class_obj)
            vpi_release_handle(_h_var_class_obj);

         vpi_release_handle(_h_var);
         continue;
      }

      if(_cur_var_class_name==NULL) {
         _h_var_class_defn = vpi_handle(vpiClassDefn, _h_var_class_obj);
         if(_h_var_class_defn) {
            _cur_var_class_name = concat_strings(_cur_var_class_name, vpi_get_str(vpiName, _h_var_class_defn));
            vpi_release_handle(_h_var_class_defn);
            _h_var_class_defn = NULL;
         }
      }

      if(!_cur_var_class_name) {
         vpi_release_handle(_h_var);
         vpi_release_handle(_h_var_class_obj);
         continue;
      }

      if(_cur_var_class_name && strcmp(_var_class_name, _cur_var_class_name)) {
         free(_cur_var_class_name);
         _cur_var_class_name = NULL;
         vpi_release_handle(_h_var);
         vpi_release_handle(_h_var_class_obj);
         continue;
      }
     
      if(_var_scope_id_str)
         free(_var_scope_id_str); 
      if(_cur_var_class_name)
         free(_cur_var_class_name);

      _decl_name_from_ary  = vpi_get_str(vpiName, _h_var);
      _var_def_file        = vpi_get_str(vpiFile, _h_var);
      _var_def_file_lineno = vpi_get(vpiLineNo, _h_var);

      pli_dhier_add_attribute(handle, "declaration_name", _decl_name_from_ary);

      char* _filename_lineno=NULL;

      _filename_lineno = (char*) malloc((sizeof(_var_def_file) + 1024) * sizeof(char));
      sprintf(_filename_lineno, "%s(%d)", _var_def_file, _var_def_file_lineno);
      pli_dhier_add_attribute(handle, "declaration_name_filename_lineno", _filename_lineno);
      if(_filename_lineno)
         free(_filename_lineno);

      vpi_release_handle(_h_var);
      vpi_release_handle(_h_var_class_obj);
      vpi_release_handle(_h_parent_class_obj);
      vpi_release_handle(_h_itr);
   
      return 1;
   }

   if(_var_scope_id_str)
      free(_var_scope_id_str); 
   if(_cur_var_class_name)
      free(_cur_var_class_name);

   if(_h_parent_class_obj)
      vpi_release_handle(_h_parent_class_obj);

   return 0;
}


#ifdef __cplusplus
}
#endif
