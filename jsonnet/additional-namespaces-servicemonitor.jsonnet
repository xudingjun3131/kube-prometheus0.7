local kp = (import 'kube-prometheus/kube-prometheus.libsonnet') + {
  _config+:: {
    namespace: 'monitoring',
    prometheus+:: {
      namespaces+: ['qiyuesuo', 'test'],
    },
  },
  prometheus+:: {
    serviceMonitorJvm: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'qiyuesuo-jvm',
        namespace: 'monitoring',
        labels: {
          'k8s-apps': 'qiyuesuo-jvm',
        },
      },
      spec: {
        endpoints: [
          {
            port: 'jvm-port',
            interval: '10s',
            path: '/metrics', 
            honorLabels: true,
          },
        ],
        selector: {
          matchLabels: {
            'prometheus-metrics': 'jvm',
          },
        },
        namespaceSelector: {
          matchNames: [
            'qiyuesuo',
          ],
        },
      },
    },
  },

};

{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
