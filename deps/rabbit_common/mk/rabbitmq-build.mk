# --------------------------------------------------------------------
# Compiler flags.
# --------------------------------------------------------------------

ifeq ($(filter rabbitmq-macros.mk,$(notdir $(MAKEFILE_LIST))),)
include $(dir $(lastword $(MAKEFILE_LIST)))rabbitmq-macros.mk
endif

# NOTE: This plugin is loaded twice because Erlang.mk recurses. That's
# why ERL_LIBS may contain twice the path to Elixir libraries or
# ERLC_OPTS may contain duplicated flags.

# Add Elixir libraries to ERL_LIBS for testsuites.
#
# We replace the leading drive letter ("C:/") with an MSYS2-like path
# ("/C/") for Windows. Otherwise, ERL_LIBS mixes `:` as a PATH separator
# and a drive letter marker. This causes the Erlang VM to crash with
# "Bad address".
#
# The space before `~r//` is apparently required. Otherwise, Elixir
# complains with "unexpected token "~"".

ELIXIR_LIB_DIR := $(shell elixir -e 'IO.puts(Regex.replace( ~r/^([a-zA-Z]):/, to_string(:code.lib_dir(:elixir)), "/\\1"))')
ifeq ($(ERL_LIBS),)
ERL_LIBS := $(ELIXIR_LIB_DIR)
else
ERL_LIBS := $(ERL_LIBS):$(ELIXIR_LIB_DIR)
endif

TEST_ERLC_OPTS += +nowarn_export_all

ifneq ($(PROJECT),rabbit_common)
# Add the CLI ebin directory to the code path for the compiler: plugin
# CLI extensions may access behaviour modules defined in this directory.
RMQ_ERLC_OPTS += -pa $(DEPS_DIR)/rabbitmq_cli/_build/dev/lib/rabbitmqctl/ebin
endif

# Add Lager parse_transform module and our default Lager extra sinks.
LAGER_EXTRA_SINKS += rabbit_log \
		     rabbit_log_channel \
		     rabbit_log_connection \
		     rabbit_log_mirroring \
		     rabbit_log_queue \
		     rabbit_log_federation \
		     rabbit_log_upgrade
lager_extra_sinks = $(subst $(space),$(comma),$(LAGER_EXTRA_SINKS))

RMQ_ERLC_OPTS += +'{parse_transform,lager_transform}' \
		 +'{lager_extra_sinks,[$(lager_extra_sinks)]}'

# Push our compilation options to both the normal and test ERLC_OPTS.
ERLC_OPTS += $(RMQ_ERLC_OPTS)
TEST_ERLC_OPTS += $(RMQ_ERLC_OPTS)
