import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany } from 'typeorm';
import { Cliente } from './cliente.entity';
import { Contacto } from './contacto.entity';
import { TipoOportunidad } from './tipo-oportunidad.entity';
import { EstadoOportunidad } from './estado-oportunidad.entity';
import { EtapaOportunidad } from './etapa-oportunidad.entity';
import { UsuarioComercial } from './usuario-comercial.entity';
import { Actividad } from './actividad.entity';

@Entity('oportunidad')
export class Oportunidad {
  @PrimaryGeneratedColumn()
  id_oportunidad: number;

  @Column({ length: 30, unique: true })
  numero_oportunidad: string;

  @Column()
  id_cliente: number;

  @Column({ nullable: true })
  id_contacto: number;

  @Column()
  id_tipo_oportunidad: number;

  @Column()
  id_estado_oportunidad: number;

  @Column()
  id_etapa_oportunidad: number;

  @Column()
  id_gestor_comercial: number;

  @Column({ nullable: true })
  id_asistente_comercial: number;

  @Column({ nullable: true })
  id_gerente_comercial: number;

  @Column({ length: 150 })
  nombre_oportunidad: string;

  @Column({ type: 'date' })
  fecha_inicio: Date;

  @Column({ type: 'date', nullable: true })
  fecha_cierre: Date;

  @Column({ default: 0 })
  actividades_abiertas: number;

  @Column({ type: 'decimal', precision: 5, scale: 2, default: 0 })
  porcentaje_avance: number;

  @Column({ length: 120, nullable: true })
  potencial: string;

  @Column()
  cierre_planificado_valor: number;

  @Column({ length: 20 })
  cierre_planificado_unidad: string;

  @Column({ type: 'date' })
  fecha_cierre_prevista: Date;

  @Column({ type: 'decimal', precision: 14, scale: 2, default: 0 })
  monto_potencial: number;

  @Column({ type: 'decimal', precision: 14, scale: 2, default: 0 })
  monto_ponderado: number;

  @Column({ length: 500, nullable: true })
  comentario_cierre: string;

  @Column({ type: 'datetime2', default: () => 'SYSDATETIME()' })
  fecha_creacion: Date;

  @Column({ type: 'datetime2', nullable: true })
  fecha_actualizacion: Date;

  @ManyToOne(() => Cliente, (cliente) => cliente.oportunidades)
  cliente: Cliente;

  @ManyToOne(() => Contacto, (contacto) => contacto.oportunidades, { nullable: true })
  contacto: Contacto;

  @ManyToOne(() => TipoOportunidad, (tipo) => tipo.oportunidades)
  tipo: TipoOportunidad;

  @ManyToOne(() => EstadoOportunidad, (estado) => estado.oportunidades)
  estado: EstadoOportunidad;

  @ManyToOne(() => EtapaOportunidad, (etapa) => etapa.oportunidades)
  etapa: EtapaOportunidad;

  @ManyToOne(() => UsuarioComercial, (usuario) => usuario.oportunidades_gestionadas)
  gestor: UsuarioComercial;

  @ManyToOne(() => UsuarioComercial, { nullable: true })
  asistente: UsuarioComercial;

  @ManyToOne(() => UsuarioComercial, { nullable: true })
  gerente: UsuarioComercial;

  @OneToMany(() => Actividad, (actividad) => actividad.oportunidad)
  actividades: Actividad[];
}
