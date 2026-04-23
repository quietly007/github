# External Audit Handoff - Ready

Generated: 2026-04-20T19:59:12Z

## Archive
/home/qui3tly/projects/qui3tly.cloud/preproduction/external/handoff/preproduction_external_audit_handoff_20260420T195850Z.tar.gz

## Verify archive integrity

tar -tzf "/home/qui3tly/projects/qui3tly.cloud/preproduction/external/handoff/preproduction_external_audit_handoff_20260420T195850Z.tar.gz" > /dev/null && echo OK

## Verify file checksums

TMPDIR=$(mktemp -d)
tar -xzf "/home/qui3tly/projects/qui3tly.cloud/preproduction/external/handoff/preproduction_external_audit_handoff_20260420T195850Z.tar.gz" -C "$TMPDIR"
B=$(find "$TMPDIR" -maxdepth 1 -type d -name 'preproduction_external_audit_handoff_*' | head -1)
cd "$B"
sha256sum -c SHA256SUMS.txt

## Required output target for external auditor
- /qui3tly/projects/qui3tly.cloud/preproduction/audits
- equivalent local path: /home/qui3tly/projects/qui3tly.cloud/preproduction/audits
