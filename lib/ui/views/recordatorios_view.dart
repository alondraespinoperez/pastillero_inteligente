import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/models/medicamento_model.dart';
import 'package:pastillero_inteligente/models/paciente_model.dart';
import 'package:pastillero_inteligente/providers/paciente_provider.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';
import 'package:pastillero_inteligente/ui/widgets/app_bar_custom.dart';
import 'package:pastillero_inteligente/ui/widgets/sidebar.dart';

class RecordatoriosView extends StatefulWidget {
  const RecordatoriosView({super.key});

  @override
  State<RecordatoriosView> createState() => _RecordatoriosViewState();
}

class _RecordatoriosViewState extends State<RecordatoriosView> {
  String _filtro = 'todos'; // todos | pendientes | completados

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PacienteProvider>();

    final List<Map<String, dynamic>> items = [];
    for (final PacienteModel p in prov.pacientes) {
      for (final MedicamentoModel m in p.listaMedicamentos) {
        items.add({'paciente': p, 'medicamento': m});
      }
    }

    // Filtrar
    if (_filtro == 'pendientes') {
      items.removeWhere(
          (i) => (i['medicamento'] as MedicamentoModel).estaCompletado);
    } else if (_filtro == 'completados') {
      items.removeWhere(
          (i) => !(i['medicamento'] as MedicamentoModel).estaCompletado);
    }

    // Ordenar por hora
    items.sort((a, b) => (a['medicamento'] as MedicamentoModel)
        .horaToma
        .compareTo((b['medicamento'] as MedicamentoModel).horaToma));

    final total = prov.pacientes
        .fold<int>(0, (s, p) => s + p.listaMedicamentos.length);
    final pendientes = prov.pacientes.fold<int>(
        0,
        (s, p) =>
            s + p.listaMedicamentos.where((m) => !m.estaCompletado).length);
    final completados = total - pendientes;

    return Scaffold(
      appBar: const AppBarCustom(titulo: 'Recordatorios'),
      drawer: const Sidebar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ────────────────────────────────
              _header(total, pendientes, completados),
              const SizedBox(height: 20),

              // ─── Chips de filtro ───────────────────────
              if (total > 0) ...[
                _chipsFiltro(),
                const SizedBox(height: 20),
              ],

              // ─── Título ────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Agenda del dia',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (items.isNotEmpty)
                    Text(
                      '${items.length} recordatorio${items.length == 1 ? "" : "s"}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // ─── Lista o estado vacío ──────────────────
              if (total == 0)
                _estadoVacioGlobal()
              else if (items.isEmpty)
                _estadoVacioFiltro()
              else
                ...items.map((i) => _recordatorioTile(
                      i['paciente'] as PacienteModel,
                      i['medicamento'] as MedicamentoModel,
                    )),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header con gradiente ──────────────────────────────────
  Widget _header(int total, int pendientes, int completados) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recordatorios',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '$total toma${total == 1 ? "" : "s"} programada${total == 1 ? "" : "s"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _miniStat(
                  icon: Icons.schedule_outlined,
                  valor: '$pendientes',
                  label: 'Pendientes',
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _miniStat(
                  icon: Icons.check_circle_outline,
                  valor: '$completados',
                  label: 'Completadas',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat({
    required IconData icon,
    required String valor,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                valor,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Chips de filtro ───────────────────────────────────────
  Widget _chipsFiltro() {
    final opciones = [
      {'key': 'todos', 'label': 'Todos', 'icon': Icons.list_alt_outlined},
      {
        'key': 'pendientes',
        'label': 'Pendientes',
        'icon': Icons.schedule_outlined
      },
      {
        'key': 'completados',
        'label': 'Completadas',
        'icon': Icons.check_circle_outline
      },
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: opciones.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final op = opciones[i];
          final activo = _filtro == op['key'];
          return GestureDetector(
            onTap: () => setState(() => _filtro = op['key'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: activo ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      activo ? AppColors.primary : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    op['icon'] as IconData,
                    size: 16,
                    color: activo
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    op['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          activo ? FontWeight.w700 : FontWeight.w500,
                      color: activo
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Estado vacío global ───────────────────────────────────
  Widget _estadoVacioGlobal() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 70,
            color: AppColors.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 14),
          const Text(
            'Sin recordatorios',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Agrega medicamentos a tus pacientes\npara verlos aqui',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => context.go('/paciente/nuevo'),
            icon: const Icon(Icons.person_add_alt_1,
                color: AppColors.primary),
            label: const Text(
              'Registrar paciente',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Estado vacío por filtro ───────────────────────────────
  Widget _estadoVacioFiltro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.filter_alt_off_outlined,
            size: 50,
            color: AppColors.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sin resultados para este filtro',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tile de recordatorio ──────────────────────────────────
  Widget _recordatorioTile(
      PacienteModel paciente, MedicamentoModel med) {
    final isPast = _esHoraPasada(med.horaToma);

    Color estadoColor;
    IconData estadoIcon;
    if (med.estaCompletado) {
      estadoColor = AppColors.primary;
      estadoIcon = Icons.check_circle;
    } else if (isPast) {
      estadoColor = AppColors.alert;
      estadoIcon = Icons.warning_amber_rounded;
    } else {
      estadoColor = AppColors.textSecondary;
      estadoIcon = Icons.schedule_outlined;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go('/paciente/${paciente.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Hora
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: estadoColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(estadoIcon, size: 18, color: estadoColor),
                    const SizedBox(height: 2),
                    Text(
                      med.horaToma,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: estadoColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      med.nombre,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'C${med.numeroCompartimento}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            med.dosis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 13,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            paciente.nombre,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Estado badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: estadoColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  med.estaCompletado
                      ? 'Tomado'
                      : (isPast ? 'Atrasado' : 'Pendiente'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: estadoColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _esHoraPasada(String horaToma) {
    try {
      final partes = horaToma.split(':');
      final hora = int.parse(partes[0]);
      final minuto = int.parse(partes[1]);
      final ahora = DateTime.now();
      final objetivo =
          DateTime(ahora.year, ahora.month, ahora.day, hora, minuto);
      return objetivo.isBefore(ahora);
    } catch (_) {
      return false;
    }
  }
}