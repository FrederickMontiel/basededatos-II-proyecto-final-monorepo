import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Oportunidad } from './oportunidad.entity';

@Entity('etapa_oportunidad')
export class EtapaOportunidad {
  @PrimaryGeneratedColumn()
  id_etapa_oportunidad: number;

  @Column({ length: 100 })
  nombre_etapa: string;

  @Column({ type: 'decimal', precision: 5, scale: 2 })
  porcentaje_cierre: number;

  @Column()
  orden_etapa: number;

  @Column({ default: true })
  estado: boolean;

  @OneToMany(() => Oportunidad, (oportunidad) => oportunidad.etapa)
  oportunidades: Oportunidad[];
}
