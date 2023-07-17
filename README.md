# Reproducer for build issue with golang + podman + QEMU

## The issue
Building an `amd64` image using podman on an ARM machine (Mac M1 Pro in my case), quite often results in `segmentation fault (core dumped)`. This happens more often with more complex golang dependencies like kubernetes.

```bash
podman build --platform=linux/amd64 --no-cache .
STEP 1/6: FROM golang:1.19-bullseye
STEP 2/6: ENV BASE=github.com/retocode/golang-qemu-podman-reproducer
--> df369ee5346e
STEP 3/6: WORKDIR ${GOPATH}/src/${BASE}
--> d3fa3914ab6a
STEP 4/6: COPY . .
--> 6b245377b005
STEP 5/6: ENV GOFLAGS="-mod=vendor"
--> 66bd0ae717e8
STEP 6/6: RUN go build $BASE

k8s.io/client-go/applyconfigurations/rbac/v1beta1: /usr/local/go/pkg/tool/linux_amd64/compile: signal: segmentation fault (core dumped)
Error: building at STEP "RUN go build $BASE": while running runtime: exit status 1
```

The same works fine with `arm64`:

```bash
podman build --platform=linux/arm64 --no-cache .

STEP 1/6: FROM golang:1.19-bullseye
Resolving "golang" using unqualified-search registries (/etc/containers/registries.conf.d/999-podman-machine.conf)
Trying to pull docker.io/library/golang:1.19-bullseye...
Getting image source signatures
Copying blob sha256:4116d88712156358c03106a493635a5014d5d52a66019a0956fd0bec49dd248f
Copying blob sha256:9d0c3fcc5367be60f92df0774820f317a179565cd3ee9c222f5500a7be32151e
Copying blob sha256:29279ac7c19f9c667f1c6b07bfba6fba20ca0d945b9fbc6edad6f75d13361fae
Copying blob sha256:5c5fa66dbb545c6ff93c768ac595d874b2f22053e8d2f842f4b6ccc310ebfe0c
Copying blob sha256:d8cfd9718ba6468cf1ee97ee10216632f123984aec4566ac6022efb0e6a3f1c8
Copying blob sha256:537cfdd6b55757672e39f135d940f749325a6e5a873a35264ffac59d747ecd11
Copying config sha256:5e82ad3b2e494bb7a278e6700b638c99cd584c4c0f2b98dc7d101653cdec4c6f
Writing manifest to image destination
Storing signatures
STEP 2/6: ENV BASE=github.com/retocode/golang-qemu-podman-reproducer
--> 38df385bf20e
STEP 3/6: WORKDIR ${GOPATH}/src/${BASE}
--> 571d073ab6b2
STEP 4/6: COPY . .
--> 6d533c673261
STEP 5/6: ENV GOFLAGS="-mod=vendor"
--> 63584373c710
STEP 6/6: RUN go build $BASE
COMMIT
--> 50ab0ed2e97a
50ab0ed2e97a09dad1e204d99d15449549bbe6b75be04f16fb7f21eb7ab9dc25
```

## More info

### Runtime info

```bash
podman version
Client:       Podman Engine
Version:      4.5.1
API Version:  4.5.1
Go Version:   go1.20.4
Git Commit:   9eef30051c83f62816a1772a743e5f1271b196d7
Built:        Fri May 26 17:10:12 2023
OS/Arch:      darwin/arm64

Server:       Podman Engine
Version:      4.5.1
API Version:  4.5.1
Go Version:   go1.20.4
Built:        Fri May 26 19:58:19 2023
OS/Arch:      linux/arm64
```

```bash
podman info
host:
  arch: arm64
  buildahVersion: 1.30.0
  cgroupControllers:
  - cpuset
  - cpu
  - io
  - memory
  - pids
  - rdma
  - misc
  cgroupManager: systemd
  cgroupVersion: v2
  conmon:
    package: conmon-2.1.7-2.fc38.aarch64
    path: /usr/bin/conmon
    version: 'conmon version 2.1.7, commit: '
  cpuUtilization:
    idlePercent: 96.3
    systemPercent: 0.2
    userPercent: 3.49
  cpus: 8
  databaseBackend: boltdb
  distribution:
    distribution: fedora
    variant: coreos
    version: "38"
  eventLogger: journald
  hostname: localhost.localdomain
  idMappings:
    gidmap: null
    uidmap: null
  kernel: 6.3.11-200.fc38.aarch64
  linkmode: dynamic
  logDriver: journald
  memFree: 10090602496
  memTotal: 16330194944
  networkBackend: netavark
  ociRuntime:
    name: crun
    package: crun-1.8.5-1.fc38.aarch64
    path: /usr/bin/crun
    version: |-
      crun version 1.8.5
      commit: b6f80f766c9a89eb7b1440c0a70ab287434b17ed
      rundir: /run/crun
      spec: 1.0.0
      +SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +CRIU +LIBKRUN +WASM:wasmedge +YAJL
  os: linux
  remoteSocket:
    exists: true
    path: /run/podman/podman.sock
  security:
    apparmorEnabled: false
    capabilities: CAP_CHOWN,CAP_DAC_OVERRIDE,CAP_FOWNER,CAP_FSETID,CAP_KILL,CAP_NET_BIND_SERVICE,CAP_SETFCAP,CAP_SETGID,CAP_SETPCAP,CAP_SETUID,CAP_SYS_CHROOT
    rootless: false
    seccompEnabled: true
    seccompProfilePath: /usr/share/containers/seccomp.json
    selinuxEnabled: true
  serviceIsRemote: true
  slirp4netns:
    executable: /usr/bin/slirp4netns
    package: slirp4netns-1.2.0-12.fc38.aarch64
    version: |-
      slirp4netns version 1.2.0
      commit: 656041d45cfca7a4176f6b7eed9e4fe6c11e8383
      libslirp: 4.7.0
      SLIRP_CONFIG_VERSION_MAX: 4
      libseccomp: 2.5.3
  swapFree: 0
  swapTotal: 0
  uptime: 3h 15m 10.00s (Approximately 0.12 days)
plugins:
  authorization: null
  log:
  - k8s-file
  - none
  - passthrough
  - journald
  network:
  - bridge
  - macvlan
  - ipvlan
  volume:
  - local
registries:
  search:
  - docker.io
store:
  configFile: /usr/share/containers/storage.conf
  containerStore:
    number: 7
    paused: 0
    running: 0
    stopped: 7
  graphDriverName: overlay
  graphOptions:
    overlay.mountopt: nodev,metacopy=on
  graphRoot: /var/lib/containers/storage
  graphRootAllocated: 106769133568
  graphRootUsed: 34020192256
  graphStatus:
    Backing Filesystem: xfs
    Native Overlay Diff: "false"
    Supports d_type: "true"
    Using metacopy: "true"
  imageCopyTmpDir: /var/tmp
  imageStore:
    number: 105
  runRoot: /run/containers/storage
  transientStore: false
  volumePath: /var/lib/containers/storage/volumes
version:
  APIVersion: 4.5.1
  Built: 1685123899
  BuiltTime: Fri May 26 19:58:19 2023
  GitCommit: ""
  GoVersion: go1.20.4
  Os: linux
  OsArch: linux/arm64
  Version: 4.5.1
```

```bash
[root@localhost ~]# rpm -q podman
podman-4.5.1-1.fc38.aarch64
```

### Podman VM journal

```text
Jul 17 13:56:47 localhost.localdomain kernel: audit: type=1334 audit(1689595007.899:1121): prog-id=138 op=LOAD
Jul 17 13:56:47 localhost.localdomain kernel: audit: type=1334 audit(1689595007.899:1122): prog-id=139 op=LOAD
Jul 17 13:56:47 localhost.localdomain kernel: audit: type=1334 audit(1689595007.899:1123): prog-id=140 op=LOAD
Jul 17 13:56:47 localhost.localdomain systemd[1]: Started systemd-coredump@7-36261-0.service - Process Core Dump (PID 36261/UID 0).
Jul 17 13:56:47 localhost.localdomain audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-coredump@7-36261-0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
Jul 17 13:56:47 localhost.localdomain kernel: audit: type=1130 audit(1689595007.939:1124): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-coredump@7-36261-0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
Jul 17 13:56:48 localhost.localdomain systemd-coredump[36269]: [🡕] Process 36258 (compile) of user 0 dumped core.

                                                               Module /usr/bin/qemu-x86_64-static from rpm qemu-7.2.1-2.fc38.aarch64
                                                               Stack trace of thread 2857:
                                                               #0  0x00000000004dbf6c have_mmap_lock (/usr/bin/qemu-x86_64-static + 0xdbf6c)
                                                               #1  0x00790000004cd860 n/a (n/a + 0x0)
                                                               #2  0x00790000004cd860 n/a (n/a + 0x0)
                                                               #3  0x00770000004dc90c n/a (n/a + 0x0)
                                                               #4  0x00630000004d886c n/a (n/a + 0x0)
                                                               #5  0x001f0000004d8fe4 n/a (n/a + 0x0)
                                                               #6  0x005a0000004dafec n/a (n/a + 0x0)
                                                               #7  0x0060000000410a8c n/a (n/a + 0x0)
                                                               #8  0x002b0000005d0590 n/a (n/a + 0x0)
                                                               #9  0x00050000005d0914 n/a (n/a + 0x0)
                                                               #10 0x00140000004112f0 n/a (n/a + 0x0)
                                                               ELF object binary architecture: AARCH64
Jul 17 13:56:48 localhost.localdomain audit[1]: SERVICE_STOP pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-coredump@7-36261-0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
Jul 17 13:56:48 localhost.localdomain kernel: audit: type=1131 audit(1689595008.019:1125): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-coredump@7-36261-0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
Jul 17 13:56:48 localhost.localdomain systemd[1]: systemd-coredump@7-36261-0.service: Deactivated successfully.
Jul 17 13:56:48 localhost.localdomain audit: BPF prog-id=140 op=UNLOAD
Jul 17 13:56:48 localhost.localdomain audit: BPF prog-id=139 op=UNLOAD
Jul 17 13:56:48 localhost.localdomain audit: BPF prog-id=138 op=UNLOAD
```

### Coredump
This happens quite a lot 😆:  

```bash
coredumpctl list
TIME                           PID UID GID SIG     COREFILE EXE                          SIZE
Fri 2023-07-14 11:55:27 CEST 67920   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.6K
Fri 2023-07-14 11:55:41 CEST 68792   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.6K
Fri 2023-07-14 11:55:49 CEST 69320   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.7K
Fri 2023-07-14 11:56:42 CEST 72956   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 57.5K
Fri 2023-07-14 11:57:03 CEST 74175   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.7K
Fri 2023-07-14 12:34:50 CEST  3060   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.6K
Fri 2023-07-14 12:35:36 CEST  5978   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 62.1K
Fri 2023-07-14 13:13:39 CEST  9602   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.7K
Fri 2023-07-14 13:13:47 CEST 10092   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.6K
Fri 2023-07-14 13:13:51 CEST 10412   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.7K
Fri 2023-07-14 13:16:12 CEST 13575   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.5K
Fri 2023-07-14 13:17:40 CEST 17401   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.6K
Mon 2023-07-17 13:23:47 CEST  3621   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.6K
Mon 2023-07-17 13:24:00 CEST  4644   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.9K
Mon 2023-07-17 13:35:40 CEST  8633   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.6K
Mon 2023-07-17 13:36:02 CEST 10378   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.7K
Mon 2023-07-17 13:38:46 CEST 19085   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.7K
Mon 2023-07-17 13:48:23 CEST 23060   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.9K
Mon 2023-07-17 13:48:44 CEST 24120   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 39.5K
Mon 2023-07-17 13:56:48 CEST 36258   0   0 SIGSEGV present  /usr/bin/qemu-x86_64-static 40.2K
```

```bash
coredumpctl info 36258
           PID: 36258 (compile)
           UID: 0 (root)
           GID: 0 (root)
        Signal: 11 (SEGV)
     Timestamp: Mon 2023-07-17 13:56:47 CEST (3min 18s ago)
  Command Line: /usr/bin/qemu-x86_64-static /usr/local/go/pkg/tool/linux_amd64/compile -o /tmp/go-build221836387/b435/_pkg_.a -trimpath $'/tmp/go-build221836387/b435=>' -p k8s.io/client-go/applyconfigurations/rbac/v1beta1 -lang=go1.19 -complete -buildid kgioK63E_GOu4ptdQ_-G/kgioK63E_GOu4ptdQ_-G -goversion go1.19.11 -c=4 -nolocalimports -importcfg /tmp/go-build221836387>
    Executable: /usr/bin/qemu-x86_64-static
 Control Group: /buildah-buildah2964934270
         Slice: -.slice
       Boot ID: c2d19ea2b38f4c63a26e21a9c2eb3ffb
    Machine ID: 210520e8d6d84227bcc4ea3a9ce37ea9
      Hostname: e8de7ef8f990
       Storage: /var/lib/systemd/coredump/core.compile.0.c2d19ea2b38f4c63a26e21a9c2eb3ffb.36258.1689595007000000.zst (present)
  Size on Disk: 40.2K
       Package: qemu/7.2.1-2.fc38
      build-id: 1c2a4d654e3a43cc0f2bc6181b332c36bcc011a0
       Message: Process 36258 (compile) of user 0 dumped core.

                Module /usr/bin/qemu-x86_64-static from rpm qemu-7.2.1-2.fc38.aarch64
                Stack trace of thread 2857:
                #0  0x00000000004dbf6c have_mmap_lock (/usr/bin/qemu-x86_64-static + 0xdbf6c)
                #1  0x00790000004cd860 n/a (n/a + 0x0)
                #2  0x00790000004cd860 n/a (n/a + 0x0)
                #3  0x00770000004dc90c n/a (n/a + 0x0)
                #4  0x00630000004d886c n/a (n/a + 0x0)
                #5  0x001f0000004d8fe4 n/a (n/a + 0x0)
                #6  0x005a0000004dafec n/a (n/a + 0x0)
                #7  0x0060000000410a8c n/a (n/a + 0x0)
                #8  0x002b0000005d0590 n/a (n/a + 0x0)
                #9  0x00050000005d0914 n/a (n/a + 0x0)
                #10 0x00140000004112f0 n/a (n/a + 0x0)
                ELF object binary architecture: AARCH64
```

See full dump [here](./core.compile.0.c2d19ea2b38f4c63a26e21a9c2eb3ffb.36258.1689595007000000.zst)

