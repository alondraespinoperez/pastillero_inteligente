import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/models/paciente_model.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/providers/paciente_provider.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';
import 'package:pastillero_inteligente/ui/widgets/app_bar_custom.dart';
import 'package:pastillero_inteligente/ui/widgets/paciente_card.dart';
import 'package:pastillero_inteligente/ui/widgets/sidebar.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _busquedaCtrl = TextEditingController();
  String _filtro = '';
  String _filtroEstado = 'todos';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PacienteProvider>().cargarPacientes();
    });
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  String get _saludo {
    final h = DateTime.now().hour;
    if (h < 12) return 'Buenos dias';
    if (h < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  List<PacienteModel> _filtrar(List<PacienteModel> pacientes) {
    var lista = pacientes;

    if (_filtro.trim().isNotEmpty) {
      final q = _filtro.toLowerCase().trim();
      lista = lista
          .where((p) =>
              p.nombre.toLowerCase().contains(q) ||
              p.idPastillero.toLowerCase().contains(q))
          .toList();
    }

    if (_filtroEstado == 'con') {
      lista = lista.where((p) => p.listaMedicamentos.isNotEmpty).toList();
    } else if (_filtroEstado == 'sin') {
      lista = lista.where((p) => p.listaMedicamentos.isEmpty).toList();
    }

    return lista;
  }

  void _mostrarDetalle(PacienteModel p) {
    context.go('/paciente/${p.id}');
  }

  @override
  Widget build(BuildContext context) {
    final pacienteProv = context.watch<PacienteProvider>();
    final authProv = context.watch<AuthProvider>();
    final filtrados = _filtrar(pacienteProv.pacientes);

    final conMedicamentos = pacienteProv.pacientes
        .where((p) => p.listaMedicamentos.isNotEmpty)
        .length;
    final totalMedicamentos = pacienteProv.pacientes
        .fold<int>(0, (sum, p) => sum + p.listaMedicamentos.length);

    return Scaffold(
      appBar: const AppBarCustom(titulo: 'Panel Medico'),
      drawer: const Sidebar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => pacienteProv.cargarPacientes(),
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            children: [
              Text(
                _saludo,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Dr. ${authProv.nombreMedico ?? "Doctor"}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 20),
              _resumenPrincipal(pacienteProv.pacientes.length,
                  conMedicamentos, totalMedicamentos),
              const SizedBox(height: 16),
              _chipsFiltro(),
              const SizedBox(height: 16),
              _buscador(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mis Pacientes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (filtrados.isNotEmpty)
                    Text(
                      '${filtrados.length} resultado${filtrados.length == 1 ? "" : "s"}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              _listaPacientes(pacienteProv, filtrados),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/paciente/nuevo'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text(
          'Nuevo Paciente',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _resumenPrincipal(int total, int conMed, int totalMeds) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
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
                  Icons.people_alt_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total de Pacientes',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '$total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Activo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _miniStat(
                  icon: Icons.medication_outlined,
                  valor: '$conMed',
                  label: 'Con tratamiento',
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _miniStat(
                  icon: Icons.schedule_outlined,
                  valor: '$totalMeds',
                  label: 'Tomas activas',
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

  Widget _chipsFiltro() {
    final opciones = [
      {'key': 'todos', 'label': 'Todos', 'icon': Icons.people_outline},
      {
        'key': 'con',
        'label': 'Con tratamiento',
        'icon': Icons.medication_outlined
      },
      {
        'key': 'sin',
        'label': 'Sin tratamiento',
        'icon': Icons.person_outline
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
          final activo = _filtroEstado == op['key'];
          return GestureDetector(
            onTap: () =>
                setState(() => _filtroEstado = op['key'] as String),
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

  Widget _buscador() {
    return TextField(
      controller: _busquedaCtrl,
      onChanged: (v) => setState(() => _filtro = v),
      decoration: InputDecoration(
        hintText: 'Buscar por nombre o ID pastillero',
        prefixIcon: const Icon(Icons.search, color: AppColors.primary),
        suffixIcon: _filtro.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _busquedaCtrl.clear();
                  setState(() => _filtro = '');
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _listaPacientes(
      PacienteProvider prov, List<PacienteModel> filtrados) {
    if (prov.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (prov.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Icon(Icons.cloud_off, size: 60, color: AppColors.alert),
            const SizedBox(height: 12),
            Text(
              prov.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => prov.cargarPacientes(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (prov.pacientes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 70,
              color: AppColors.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            const Text(
              'No hay pacientes registrados',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => context.go('/paciente/nuevo'),
              icon: const Icon(Icons.add, color: AppColors.primary),
              label: const Text(
                'Agregar el primero',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      );
    }

    if (filtrados.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Text(
            'Sin resultados para tu busqueda',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: filtrados
          .map((p) => PacienteCard(
                paciente: p,
                onTap: () => _mostrarDetalle(p),
              ))
          .toList(),
    );
  }
}