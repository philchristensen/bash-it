# insite account theming
INSITE_THEME_ACCOUNT_PREFIX="${cyan}"
INSITE_THEME_ACCOUNT_SUFFIX="${normal}"
INSITE_THEME_REGION_PREFIX=""
INSITE_THEME_REGION_SUFFIX=""
INSITE_THEME_EXP_PREFIX=" ${yellow}"
INSITE_THEME_EXP_SUFFIX="${normal}"

# scm theming
SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN=" ${green}✓${normal}"
SCM_GIT_CHAR="${green}"
SCM_SVN_CHAR="${bold_cyan}✶ "
SCM_HG_CHAR="${bold_red}✷ "

VIRTUALENV_THEME_PROMPT_PREFIX="${bold_red}"
VIRTUALENV_THEME_PROMPT_SUFFIX="${normal} "

### TODO: openSUSE has already colors enabled, check if those differs from stock
# LS colors, made with http://geoff.greer.fm/lscolors/
# export LSCOLORS="Gxfxcxdxbxegedabagacad"
# export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'

function displaytime {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  (( $D > 0 )) && printf '%dd' $D
  (( $H > 0 )) && printf '%dh' $H
  (( $M > 0 )) && printf '%dm' $M
  (( $D > 0 || $H > 0 || $M > 0 ))
  printf '%ds' $S
}

function insite_prompt() {
    insite_acc="$INSITE_THEME_ACCOUNT_PREFIX$(insite_account)$INSITE_THEME_ACCOUNT_SUFFIX"
    insite_reg="$INSITE_THEME_REGION_PREFIX$(aws_region)$INSITE_THEME_ACCOUNT_SUFFIX"
    insite_exp="$INSITE_THEME_EXP_PREFIX$(displaytime $(($INSITE_EXPIRATION - $(date +%s))))$INSITE_THEME_EXP_SUFFIX"
    
    if [[ -n "$INSITE_ACCOUNT" ]]; then 
        echo "$insite_acc$insite_reg$insite_exp"
    fi 
}

function scm_prompt() {
    CHAR=$(scm_char) 
    if [ $CHAR = $SCM_NONE_CHAR ] 
        then 
            return
        else 
            echo "[$(scm_char)$(scm_prompt_info)]"
    fi 
}

function bubblehouse_prompt() {
    ps_host="${bold_blue}\h${normal}";
    ps_user="${green}\u${normal}";
    ps_user_mark="${green} $ ${normal}";
    ps_root="${red}\u${red}";
    ps_root_mark="${red} # ${normal}"
    ps_path="${yellow}\w${normal}";
    
    ps_sep=""
    if [[ -n "$VIRTUAL_ENV" ]] || [[ -n "$INSITE_ACCOUNT" ]]; then
      ps_sep="\n"
    fi


    # make it work
    case $(id -u) in
        0) PS1="$(virtualenv_prompt)$(insite_prompt)$ps_sep$ps_host$(scm_prompt):$ps_path$ps_root_mark"
            ;;
        *) PS1="$(virtualenv_prompt)$(insite_prompt)$ps_sep$ps_host$(scm_prompt):$ps_path$ps_user_mark"
            ;;
    esac
}

safe_append_prompt_command bubblehouse_prompt
