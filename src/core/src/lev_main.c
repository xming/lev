/*
 *  Copyright 2012 The Luvit Authors. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

#include <string.h>
#include <stdlib.h>
#include <limits.h> /* PATH_MAX */

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#ifndef WIN32
#include <pthread.h>
#endif
#include "uv.h"

#include "lev_main.h"
#include "lev_init.h"
#include "luv.h"

#ifdef BUNDLE
#include "lev_exports.h"
#endif

int main(int argc, char *argv[])
{
  lua_State *L;
  uv_loop_t *loop;

  argv = uv_setup_args(argc, argv);

  L = luaL_newstate();
  if (L == NULL) {
    fprintf(stderr, "luaL_newstate has failed\n");
    return 1;
  }

  luaL_openlibs(L);

  loop = uv_default_loop();

#ifdef LUV_EXPORTS
  lev__suck_in_symbols();
#endif

#ifdef USE_OPENSSL
  lev_init_ssl();
#endif

  if (lev_init(L, loop, argc, argv)) {
    fprintf(stderr, "lev_init has failed\n");
    return 1;
  }

  /* Run the main lua script */
  if (lev_run(L)) {
    printf("%s\n", lua_tostring(L, -1));
    lua_pop(L, 1);
    lua_close(L);
    return -1;
  }

  lua_close(L);
  return 0;
}
